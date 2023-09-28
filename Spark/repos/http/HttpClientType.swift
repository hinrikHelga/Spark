//
//  HttpClientType.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

public enum HttpVerb: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Represents a coder for encoding/decoding the request/response body
/// - Remark: See the JsonDataCoder for an implementation.
public protocol HttpClientCoder: DataCoder {
    var contentType: String { get }
    var acceptType: String { get }
}

/// Provides a factory for creating requests
public protocol HttpClientRequestFactoryType {
    var configuration: HttpClientRequestConfiguration { get }
    func createRequest(url: URL, method: HttpVerb, body: Data?) -> HttpClientRequest
}

/// Protocol for making a request
/// - Remark: This protocol is necessary so that we may unit test our HttpClient implementation
public protocol HttpClientRequest {
    var url: URL { get set }
    var method: HttpVerb { get set }
    var configuration: HttpClientRequestConfiguration { get }
    var body: Data? { get set }
    func requestResponse() async throws -> (data: Data?, response: URLResponse?)
}

/// Configures an Http client request
public struct HttpClientRequestConfiguration {
    public let coder: HttpClientCoder
    public let headers: [String:String]?

    public init(coder: HttpClientCoder, headers: [String : String]?) {
        self.coder = coder
        self.headers = headers
    }
}


/// Defines the interface of a component that can communicate via HTTP
public protocol HttpClientType {


    /// Executes an ``HttpVerb.get`` request
    /// - Parameter url: The url to send the request to
    /// - Returns: The decoded body received in the response
    func get<R>(url: URL) async throws -> R where R : Decodable

    /// Executes an ``HttpVerb.get`` request
    /// - Parameter url: The url to send the request to
    func get(url: URL) async throws


    /// Executes an ``HttpVerb.post`` request
    /// - Parameters:
    ///   - url: The url to send the request to
    ///   - data: Content to include in the request body
    /// - Returns: The decoded body received in the response
    func post<R, D>(url: URL, data: D) async throws -> R where R: Decodable, D: Encodable

    /// Executes an ``HttpVerb.post`` request
    /// - Parameters:
    ///   - url: The url to send the request to
    ///   - data: Content to include in the request body
    func post<D>(url: URL, data: D) async throws where D: Encodable

    /// Executes an ``HttpVerb.put`` request
    /// - Parameters:
    ///   - url: The url to send the request to
    ///   - data: Content to include in the request body
    /// - Returns: The decoded body received in the response
    func put<R, D>(url: URL, data: D) async throws -> R where R: Decodable, D: Encodable

    /// Executes an ``HttpVerb.put`` request
    /// - Parameters:
    ///   - url: The url to send the request to
    ///   - data: Content to include in the request body
    func put<D>(url: URL, data: D) async throws where D: Encodable


    /// Executes an ``HttpVerb.delete`` request
    /// - Parameter url: The url to send the request to
    /// - Returns: The decoded body received in the response
    func delete<R>(url: URL) async throws -> R where R : Decodable

    /// Executes an ``HttpVerb.delete`` request
    /// - Parameter url: The url to send the request to
    func delete(url: URL) async throws

    /// Executes an ``HttpVerb.delete`` request
    /// - Parameters:
    ///   - url: The url to send the request to
    ///   - data: Content to include in the request body
    func delete<D>(url: URL, data: D) async throws where D: Encodable
}

/// Defines an ``HttpClientType`` that can be used for previews
struct PreviewHttpClient: HttpClientType {
    func get<R>(url: URL) async throws -> R where R : Decodable {
        fatalError("Not implemented")
    }

    func get(url: URL) async throws {
        fatalError("Not implemented")
    }

    func post<R, D>(url: URL, data: D) async throws -> R where R : Decodable, D : Encodable {
        fatalError("Not implemented")
    }

    func post<D>(url: URL, data: D) async throws where D : Encodable {
        fatalError("Not implemented")
    }

    func put<R, D>(url: URL, data: D) async throws -> R where R : Decodable, D : Encodable {
        fatalError("Not implemented")
    }

    func put<D>(url: URL, data: D) async throws where D : Encodable {
        fatalError("Not implemented")
    }

    func delete<R>(url: URL) async throws -> R where R : Decodable {
        fatalError("Not implemented")
    }

    func delete(url: URL) async throws {
        fatalError("Not implemented")
    }

    func delete<D>(url: URL, data: D) async throws where D : Encodable {
        fatalError("Not implemented")
    }
}
