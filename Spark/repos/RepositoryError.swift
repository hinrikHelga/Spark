//
//  RepositoryError.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Defines errors that are thrown from a ``RepositoryType``
enum RepositoryError: Error, Equatable {

    /// The functionality is not supported
    case notSupported
    /// A requested resource was not found
    case notFound
    /// An error occurred; see ``reason`` for an explanation
    ///
    /// - reason: A programmer-directed explanation of the error (not presentable to an end-user).
    case error(reason: String)
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {

        case .notSupported: return "Den anmodede handling er ikke understøttet"
        case .notFound: return "Ressourcen ikke fundet"
        case .error(let reason): return reason
        }
    }
}
