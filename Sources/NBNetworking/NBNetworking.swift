//
//  NBNetworking.swift
//  Paypay
//
//  Created by Navnit Baldha on 20/04/23.
//

import Foundation
import Combine

public protocol Networking {
    func get<T: Codable>(
        requestUrl: String,
        header: [String: String]?
    ) -> AnyPublisher<T, NBURLSessionError>
    
}

public class NetworkingClient {
    private let urlSession: NBURLSession
    let baseUrl: String
    public init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.urlSession = NBURLSession()
    }
}

public enum httpMothod {
    case get
    case post
}

public struct NBRequestObject {
    public var urlStr: String?
    public var httpMethod: httpMothod = .get
    public var httpBodyData: Date?
    public init() { }
}

extension NetworkingClient: Networking {
    public func get<T>(requestUrl: String, header: [String : String]?) -> AnyPublisher<T, NBURLSessionError> where T : Decodable, T : Encodable {
        return request(requestURl: requestUrl, httpMethod: .get, header: header)
    }

    private func request<T: Codable>(
        requestURl: String,
        httpMethod: httpMothod = .get,
        header: [String: String]? = nil,
        body: [String: Any]? = nil
    ) -> AnyPublisher<T, NBURLSessionError> {

        var request = NBRequestObject()
        request.urlStr = "\(baseUrl)\(requestURl)"
        request.httpMethod = httpMethod

        return urlSession.createSessionTaskPublisher(requestObj: request)
    }
}

