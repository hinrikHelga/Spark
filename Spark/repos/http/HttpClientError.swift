//
//  HttpClientError.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Possible errors for an http client
public enum HttpClientError: Error {
    case
    /// Operation failed with an http error
    httpError(HttpError),
    /// A general error occurred. The inner error may contain additional information
    general(_ innerError: Error?),
    /// Data received could not be decoded. The inner error may contain additional information
    decodingFailed(_ innerError: Error?),
    /// Data received was empty
    dataEmpty,
    /// No network connection
    noNetwork
}

extension HttpClientError: LocalizedError {
    public var errorDescription: String? {

        switch self {

        case .httpError(let httpError):
            return "Http error: \(httpError.localizedDescription)"
        case .general(let innerError):
            return innerError?.localizedDescription ?? "Generel fejl (ukendt årsag)"
        case .decodingFailed(let innerError):
            return "Decoding fejlede: \(innerError?.localizedDescription ?? "Ukendt årsag")"
        case .dataEmpty:
            return "Data var tom"
        case .noNetwork:
            return "Ingen netværksforbindelse"
        }
    }
}
