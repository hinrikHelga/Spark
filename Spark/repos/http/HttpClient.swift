//
//  HttpClient.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Represents an empty HTTP response
///
/// This is used to support a generic response even in cases where no response is received for decoding.
public struct EmptyHttpResponse: Codable {}
extension EmptyHttpResponse: Equatable {}


/// Provides a client supporting making HTTP requests and receiving a response
public class HttpClient: HttpClientType {
    @Injected private var requestFactory: HttpClientRequestFactoryType
    @Injected private var reachability: ReachabilityType
    private var coder: HttpClientCoder {
        requestFactory.configuration.coder
    }

    public init() {}

    public func get<R>(url: URL) async throws -> R where R : Decodable {
        let request = requestFactory.createRequest(url: url, method: .get, body: nil)
        return try await execute(request: request)
    }

    public func get(url: URL) async throws {
        let request = requestFactory.createRequest(url: url, method: .get, body: nil)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    public func get<R, D>(url: URL, data: D) async throws -> R where R : Decodable, D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .get, body: body)
        return try await execute(request: request)
    }

    public func get<D>(url: URL, data: D) async throws where D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .get, body: body)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    public func post<R, D>(url: URL, data: D) async throws -> R where R : Decodable, D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .post, body: body)
        return try await execute(request: request)
    }

    public func post<D>(url: URL, data: D) async throws where D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .post, body: body)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    public func put<R, D>(url: URL, data: D) async throws -> R where R : Decodable, D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .put, body: body)
        return try await execute(request: request)
    }

    public func put<D>(url: URL, data: D) async throws where D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .put, body: body)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    public func delete<R>(url: URL) async throws -> R where R : Decodable {
        let request = requestFactory.createRequest(url: url, method: .delete, body: nil)
        return try await execute(request: request)
    }

    public func delete(url: URL) async throws {
        let request = requestFactory.createRequest(url: url, method: .delete, body: nil)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    public func delete<D>(url: URL, data: D) async throws where D : Encodable {
        let body = try coder.encode(value: data)
        let request = requestFactory.createRequest(url: url, method: .delete, body: body)
        let _: EmptyHttpResponse = try await execute(request: request)
    }

    private func execute<R>(request: HttpClientRequest) async throws -> R where R: Decodable {
        guard reachability.isConnectedToNetwork() else {
            throw HttpClientError.noNetwork
        }

        do {
            let result = try await request.requestResponse()

            if let httpResponse = result.response as? HTTPURLResponse {
                if HttpStatusCode.isError(statusCode: httpResponse.statusCode)  {
                    let statusCode = HttpStatusCode(rawValue: httpResponse.statusCode) ?? HttpStatusCode.badRequest
                    throw HttpClientError.httpError(HttpError(statusCode: statusCode))
                }
            }

            // Handle empty response
            if R.self == EmptyHttpResponse.self {
                return EmptyHttpResponse() as! R
            }

            // Handle data from response
            else if let data = result.data, data.count > 0 {
                if R.self == Data.self {
                    return data as! R
                } else {
                    do {
                        let decoded: R = try coder.decode(data: data)
                        return decoded
                    } catch {
                        throw HttpClientError.decodingFailed(error)
                    }
                }
            }

            // We received no data, which is unexpected, so throw
            else {
                throw HttpClientError.dataEmpty
            }

        } catch let httpError as HttpClientError {
            throw httpError
        } catch {
            throw HttpClientError.general(error)
        }
    }
}
