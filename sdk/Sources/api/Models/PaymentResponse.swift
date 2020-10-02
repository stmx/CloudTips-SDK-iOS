//
//  PaymentResponse.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import ObjectMapper

enum PaymentResponseStatus: String {
    case success = "Success"
    case failure = "Failure"
    case need3ds = "Need3ds"
}

public struct PaymentResponse: Mappable {
    private(set) var transactionId: String?
    private(set) var md: String?
    private(set) var paReq: String?
    private(set) var acsUrl: String?
    private(set) var message: String?
    private(set) var status: PaymentResponseStatus?
    private(set) var cardToken: String?
    private(set) var partnerRedirectUrl: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        transactionId <- map["transactionId"]
        md <- map["md"]
        paReq <- map["paReq"]
        acsUrl <- map["acsUrl"]
        message <- map["message"]
        status <- (map["statusCode"], PaymentResponseStatusTransformer())
        cardToken <- map["cardToken"]
        partnerRedirectUrl <- map["partnerRedirectUrl"]
    }
    
    private class PaymentResponseStatusTransformer: TransformType {
        typealias Object = PaymentResponseStatus
        typealias JSON = String
        
        func transformFromJSON(_ value: Any?) -> PaymentResponseStatus? {
            guard let value = value as? String else { return nil }
            return PaymentResponseStatus(rawValue: value)
        }
        
        func transformToJSON(_ value: PaymentResponseStatus?) -> String? {
            return value?.rawValue
        }
    }

}
