//
//  HttpStatusCode.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

/// Enumerates the status codes in the Http protocol
public enum HttpStatusCode: Int, CaseIterable {
    // 100 Informational
    case continueCode = 100
    case switchingProtocols
    case processing
    // 200 Success
    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case iMUsed = 226
    // 300 Redirection
    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permanentRedirect
    // 400 Client Error
    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest = 421
    case unprocessableEntity
    case locked
    case failedDependency
    case UpgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests
    case requestHeaderFieldsTooLarge = 431
    case UnavailableForLegalReasons = 451
    // 500 Server Error
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended = 510
    case networkAuthenticationRequired

    static func isError(statusCode: Int) -> Bool {
        return statusCode < 200 || statusCode > 299
    }

    static func isServerError(statusCode: Int) -> Bool {
        (500..<600) ~= statusCode
    }
}

extension HttpStatusCode {
    var isError: Bool {
        HttpStatusCode.isError(statusCode: self.rawValue)
    }

    var isServerError: Bool {
        HttpStatusCode.isServerError(statusCode: self.rawValue)
    }

    static func getErrorCodes() -> [HttpStatusCode] {
        allCases.filter { $0.isError }
    }
}
