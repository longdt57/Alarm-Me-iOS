//
//  RequestConfiguration.swift
//

import Alamofire
import Foundation

public protocol RequestConfiguration {

    var baseURL: String { get }

    var endpoint: String { get }

    var method: HTTPMethod { get }

    var url: URLConvertible { get }

    var parameters: Parameters? { get }

    var encoding: ParameterEncoding { get }

    var headers: HTTPHeaders? { get }

    var interceptor: RequestInterceptor? { get }
}

extension RequestConfiguration {

    public var url: URLConvertible {
        let url = URL(string: baseURL)?.appendingPathComponent(endpoint)
        return url?.absoluteString ?? "\(baseURL)\(endpoint)"
    }

    public var parameters: Parameters? { nil }

    public var headers: HTTPHeaders? { nil }

    public var interceptor: RequestInterceptor? { nil }

    public var encoding: ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
