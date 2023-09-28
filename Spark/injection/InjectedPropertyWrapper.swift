//
//  InjectedPropertyWrapper.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Property wrapper for a property accessing a registered dependency
///
/// ```
/// //
/// // Example usage
/// //
/// protocol DependencyType {
///     var text: String { get }
/// }
///
/// class ConcreteDependency: DependencyType {
///     var text: String = ""
/// }
///
/// class SetupClass {
///     func setupDependencies() {
///
///         // Use either a factory or a singleton
///         // Latest registration will win
///
///         // Register a factory – creates a new instance for each dependent object
///         DependencyContainer.shared.register {
///             ConcreteDependency() as DependencyType
///         }
///
///         // Register a singleton – creates the same instance for all dependent objects
///         DependencyContainer.shared.register(singleton: ConcreteDependency() as DependencyType)
///     }
/// }
///
/// class DependentClass {
///     // Use the property wrapper to have the dependency injected
///     @Injected private var dependency: DependencyType
///
///     func foo() {
///         let bar = dependency.text
///     }
/// }
/// ```
@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T {
        dependency
    }

    private var dependency: T

    public init() {
        self.dependency = try! DependencyContainer.shared.get()
    }
}
