//
//  HttpDataDownloader.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// A protocol describing an HTTP Data Downloader.
public protocol HTTPDataDownloader {
    func httpData(from: URL) async throws -> Data
}

enum HTTPDataDownloaderError: Error {
    case networkError
}

extension URLSession: HTTPDataDownloader {
    public func httpData(from url: URL) async throws -> Data {
        guard let (data, response) = try await self.data(from: url) as? (Data, HTTPURLResponse),
              !HttpStatusCode.isError(statusCode: response.statusCode)
              else {
            throw HTTPDataDownloaderError.networkError
        }

        return data
    }
}
