//
//  HttpError.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

public struct HttpError: Error {
    public let statusCode: HttpStatusCode
    public let data: Data?

    init(statusCode: HttpStatusCode, data: Data? = nil) {
        self.statusCode = statusCode
        self.data = data
    }
}

extension HttpError: Equatable {}

extension HttpError: CustomDebugStringConvertible {
    public var debugDescription: String {
        var result = "HttpError: \(localizedDescription) (status code \(self.statusCode.rawValue))"

        if let data = self.data, let s = String(data: data, encoding: .utf8) {
            result += ". Data: \(s)"
        }

        return result
    }
}

extension HttpError: LocalizedError {
    public var errorDescription: String? {
        "\(HTTPURLResponse.localizedString(forStatusCode: statusCode.rawValue)) (\(statusCode.rawValue))"
    }
}
