//
//  URLSessionHttpClient.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

public class URLSessionHttpClientRequest: HttpClientRequest {
    private var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }
    private var request: URLRequest {
        var result = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        // Set the headers
        result.allHTTPHeaderFields = configuration.headers
        result.setValue(configuration.coder.contentType, forHTTPHeaderField: "Content-Type")
        result.setValue(configuration.coder.acceptType, forHTTPHeaderField: "Accept")

        // Set the verb
        result.httpMethod = self.method.rawValue

        // Set the body
        result.httpBody = self.body

        return result
    }
    public var url: URL
    public var method: HttpVerb
    public var configuration: HttpClientRequestConfiguration
    public var body: Data?

    public init(url: URL, method: HttpVerb, configuration: HttpClientRequestConfiguration, body: Data? = nil) {
        self.url = url
        self.method = method
        self.configuration = configuration
        self.body = body
    }

    public func requestResponse() async throws -> (data: Data?, response: URLResponse?) {
        return try await session.data(for: request)
    }
}

open class URLSessionHttpClientRequestFactory: HttpClientRequestFactoryType {
    public var configuration: HttpClientRequestConfiguration

    public init(configuration: HttpClientRequestConfiguration) {
        self.configuration = configuration
    }

    open func createRequest(url: URL, method: HttpVerb, body: Data?) -> HttpClientRequest {
        return URLSessionHttpClientRequest(url: url, method: method, configuration: configuration, body: body)
    }
}
