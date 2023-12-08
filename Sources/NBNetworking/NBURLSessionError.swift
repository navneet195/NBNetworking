//
//  NBURLSessionError.swift
//  Paypay
//
//  Created by Navnit Baldha on 20/04/23.
//

import Foundation

public enum NBURLSessionError: Error {
    case statusCodeError(statusCode: Int)
    case responseError
    case decodeError
    case other(Error)
    case requestObjError
    case networkNotRechableError

    static func map(_ error: Error) -> NBURLSessionError {
        debugPrint(error)
        return error as? NBURLSessionError ?? .other(error)
    }

    public func logError() {
        switch self {
        case .other(let error):
            debugPrint(error)
        default:
            debugPrint("XXXXXXX NBURLSessionError -------> \(self)")
        }
    }
}
