//
//  NBURLSession.swift
//  Paypay
//
//  Created by Navnit Baldha on 20/04/23.
//

import Foundation
import SwiftUI
import Combine

public class NBURLSession {

    private var session: URLSession?
    private var isReachable: Bool = true

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func createSessionTaskPublisher<T: Codable>(requestObj request: NBRequestObject) -> AnyPublisher<T, NBURLSessionError> {
        if isReachable {
            guard let tempRequest = createURLRequest(formRequestObj: request) else {
                return Fail(error: NBURLSessionError.requestObjError).eraseToAnyPublisher()
            }
            
            guard let objSession = session else {
                return Fail(error: NBURLSessionError.requestObjError).eraseToAnyPublisher()
            }

            return objSession.dataTaskPublisher(for: tempRequest)
                .tryMap ({ (result) -> Data  in
                    guard let tempResponseCode = result.response as? HTTPURLResponse else {
                        throw NBURLSessionError.responseError
                    }

                    switch tempResponseCode.statusCode {
                    case (200...299):
                        return result.data
                    default:
                        throw NBURLSessionError.statusCodeError(statusCode: tempResponseCode.statusCode)
                    }
                })
                .tryMap ({ (modelData) in
                    if T.self == Data.self {
                        guard let validModelData = modelData as? T else {
                            throw NBURLSessionError.responseError
                        }
                        return validModelData
                    } else {
                        let model = try JSONDecoder().decode(T.self, from: modelData)
                        return model
                    }
                })
                .retry(1)
                .mapError({ (error) in
                    .map(error)
                })
                .eraseToAnyPublisher()
        }
        else {
            return Fail(error:  NBURLSessionError.networkNotRechableError).eraseToAnyPublisher()
        }
    }

    private func createURLRequest(formRequestObj objRequest: NBRequestObject) -> URLRequest? {
        var request: URLRequest? = nil
        if let tempUrlStr = objRequest.urlStr, let tempUrl = URL(string: tempUrlStr) {
            request = URLRequest(url: tempUrl)

            switch objRequest.httpMethod {
            case .get:
                request?.httpMethod = "GET"
            case .post:
                request?.httpMethod = "POST"

            }
        }
        return request
    }
}
