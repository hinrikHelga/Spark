//
//  ApiConfigurationType.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Defines the configuration for the API
protocol ApiConfigurationType {
    /// Gets the base url for requests to the API
    var baseUrl: URL { get }
}

struct ApiConfiguration: ApiConfigurationType {
    
    let baseUrl: URL

    /// Creates a new instance, if the API has been configured with valid values
    init?() {
        // Read the values from our Info.plist file.
        // The values ultimately point to the Environment.xcconfiguration file
        guard let dict: [String:String] = try? ConfigurationReader.getValueFor(key: "API") else { return nil }
        guard
            let urlString = dict["BaseUrl"],
            let baseUrl = URL(string: "https://" + urlString) else { return nil }

        self.baseUrl = baseUrl
    }
}

/// Reads settings from the Info.plist file baked into the app executable
struct ConfigurationReader {
    /// Defines possible errors thrown when reading a value
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }


    /// Reads the value for the specified key
    /// - Parameter key: The key in the info dictionary to retrieve a value for
    /// - Returns: The value for the specified key, if it exists; otherwise, an error is thrown
    static func getValueFor<T>(key: String) throws -> T {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }

        guard let result = object as? T else {
            throw Error.invalidValue
        }

        return result
    }
}

