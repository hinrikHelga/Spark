//
//  DependencyContainer.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Defines possible errors for the ``DependencyContainer``
public enum DependencyContainerError: Error {
    /// The requested dependency has not been registered
    case dependencyNotFound(className: String)
}

/// Contains all shared dependencies for the entire app
public class DependencyContainer {
    /// Registry dictionary storing singleton/factory closure for each registered type.
    private var registry = [String: Any]()
    /// Gets the shared instance of the ``DependencyContainer``
    public static let shared = DependencyContainer()
    private init() { /* No new instance of this can be created; the shared one must be used */ }

    /// Registers a factory to create instances of T
    ///
    /// Always make sure to cast a concrete implementation to the protocol type used by dependent objects to retrieve the dependency, e.g.:
    /// ```
    /// DependencyContainer.shared.register {
    ///     ConcreteDependency() as DependencyType
    /// }
    /// ```
    ///
    /// - Parameter factory: The factory closure producing an instance of T
    public func register<T>(factory: @escaping () -> T) {
        let key = getStringKey(from: T.self)
        registry[key] = factory
    }

    /// Registers a singleton instance
    ///
    /// Always make sure to cast a concrete implementation to the protocol type used by dependent objects to retrieve the dependency, e.g.:
    /// ```
    /// DependencyContainer.shared.register(singleton:
    ///     ConcreteDependency() as DependencyType
    /// )
    /// ```
    ///
    /// - Parameter singleton: The singleton instance to register
    public func register<T>(singleton: T) {
        let key = getStringKey(from: T.self)
        registry[key] = singleton
    }

    /// Gets a dependency
    /// - Returns: The registered dependency
    public func get<T>() throws -> T {
        let key = getStringKey(from: T.self)

        // Determine if there's a factory registered
        if let factory = registry[key] as? () -> T {
            // Let the factory produce our result
            return factory()
        }

        // Determine if there's a singleton registered
        else if let singleton = registry[key] as? T {
            // Return the singleton
            return singleton
        }

        // No result found
        throw DependencyContainerError.dependencyNotFound(className: "\(T.self)")
    }

    /// Clears all registered dependencies
    public func clear() {
        registry.removeAll()
    }
}

private extension DependencyContainer {
    func getStringKey<T>(from: T) -> String {
        let result = String(describing: T.self)
        return result
    }
}
