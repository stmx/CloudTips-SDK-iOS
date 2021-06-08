//
//  HTTP.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Alamofire
import ObjectMapper

struct HTTPRequest {
    
    let resource: HTTPResource
    
    let method: HTTPMethod
    
    let headers: HTTPHeaders
    
    let parameters: Parameters
    
    let mappingKeyPath: String?
    
    init(resource: HTTPResource,
         method: HTTPMethod = .get,
         headers: HTTPHeaders = [:],
         parameters: Parameters = [:],
         
         
         mappingKeyPath: String? = nil) {
        
        self.resource = resource
        self.method = method
        self.headers = headers
        self.parameters = parameters
        
        self.mappingKeyPath = mappingKeyPath
    }
}

enum HTTPResource: URLConvertible {
    static let baseURLString = "https://pay.cloudtips.ru/"
    
    static let baseApiProdURLString = "https://lk.cloudtips.ru/api/"
    static let baseApiPreprodURLString = "https://lk-preprod.cloudtips.ru/api/"
    static var baseApiURLString = baseApiProdURLString
    
    case getLayout(String)
    case offlineRegister
    case getPublicId
    case authPayment
    case post3ds
    case captchaVerify
    case getPaymentPages(String)
    
    func asURL() throws -> URL {
        guard let baseURL = URL(string: HTTPResource.baseApiURLString) else {
            throw AFError.invalidURL(url: HTTPResource.baseApiURLString)
        }
        
        switch self {
        case .getLayout(let phoneNumber):
            return baseURL.appendingPathComponent("layouts/list/\(phoneNumber)")
        case .offlineRegister:
            return baseURL.appendingPathComponent("auth/offlineregister")
        case .getPublicId:
            return baseURL.appendingPathComponent("payment/publicId")
        case .authPayment:
            return baseURL.appendingPathComponent("payment/auth")
        case .post3ds:
            return baseURL.appendingPathComponent("payment/post3ds")
        case .captchaVerify:
            return baseURL.appendingPathComponent("captcha/verify")
        case .getPaymentPages(let layoutId):
            return baseURL.appendingPathComponent("paymentPages/\(layoutId)")
        }
    }
}

public typealias HTTPRequestCompletion<Success> = (_ value: Success?, _ error: Error?) -> ()
