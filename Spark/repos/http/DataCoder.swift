//
//  DataCoder.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//


import Foundation
import OSLog

/// Encodes and decodes data
public protocol DataCoder {
    func decode<T>(data: Data) throws -> T where T : Decodable
    func encode<T>(value: T) throws -> Data where T : Encodable
}

/// An implementation of ``DataCoder`` supporting JSON
public class JsonDataCoder: HttpClientCoder {
    private static let dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "yyy-MM-dd"
        return result
    }()
    private let decoder: JSONDecoder = {
        let result = JSONDecoder()
        result.dateDecodingStrategy = .formatted(dateFormatter)
        return result
    }()
    private let encoder: JSONEncoder = {
        let result = JSONEncoder()
        result.dateEncodingStrategy = .formatted(dateFormatter)
        return result
    }()

    private(set) public var contentType: String = "application/json"
    private(set) public var acceptType: String = "application/json"

    public init() {}

    public func decode<T>(data: Data) throws -> T where T : Decodable {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            let dataString = String(data: data, encoding: .utf8) ?? "<unable to decode data as string>"
            #else
            let dataString = "<unavailable in non-debug build>"
            #endif
            Logger().error("Failed to decode JSON: Error: \(error)\nData: \(dataString)")
            throw error
        }
    }
    public func encode<T>(value: T) throws -> Data where T : Encodable {
        // If value is Data we should not encode it
        if let data = value as? Data {
            return data
        }

        return try encoder.encode(value)
    }
}
