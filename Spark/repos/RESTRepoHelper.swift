//
//  RESTRepoHelper.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

///// Provides re-usable logic for REST repositories
struct RESTRepoHelper {
    /// Gets the trailing URL fragment identifying the concrete endpoint
    let endpointUrlFragment: String

    /// Gets the HTTP Client to use
    @Injected var httpClient: HttpClientType

    /// Gets the API configuration to use
    @Injected var apiConfig: ApiConfigurationType

    /// Gets the complete URL to the endpoint as a string
    var endpointUrlString: String {
        apiConfig.baseUrl.absoluteString + endpointUrlFragment
    }

    func getAll<T>() async throws -> [T] where T: Decodable {
        let url = try url(suffix: nil, queryParams: nil)

        do {
            let result: [T] = try await httpClient.get(url: url)
            return result
        } catch {
            throw RepositoryError.error(reason: error.localizedDescription)
        }
    }

    func getList<T>(urlSuffixString: String? = nil, queryParams: [(String, String)]? = nil) async throws -> [T] where T: Decodable {

        let url = try url(suffix: urlSuffixString, queryParams: queryParams)

        do {
            let result: [T] = try await httpClient.get(url: url)
            return result
        } catch {
            throw RepositoryError.error(reason: error.localizedDescription)
        }

    }

    func get<T>(urlSuffixString: String? = nil, queryParams: [(String, String)]? = nil) async throws -> T where T: Decodable {
        let url = try url(suffix: urlSuffixString, queryParams: queryParams)

        do {
            let result: T = try await httpClient.get(url: url)
            return result
        } catch {
            throw RepositoryError.error(reason: error.localizedDescription)
        }
    }
}

extension RESTRepoHelper {
    func url(suffix: String?, queryParams: [(String, String)]?) throws -> URL {
        var urlString = endpointUrlString
        if let suffix = suffix {
            urlString += "/" + suffix
        }
        urlString += queryParamsUrlArguments(params: queryParams)

        guard let url = URL(string: urlString) else {
            throw RepositoryError.error(reason: "Invalid url: \(urlString)")
        }

        return url
    }

    private func queryParamsUrlArguments(params: [(String, String)]?) -> String {
        guard let params = params, params.count > 0 else { return "" }

        let queryParams = params.map { (key, value) in
            let val = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            return "\(key)=\(val)"
        }

        return "?" + queryParams.joined(separator: "&")
    }
}
