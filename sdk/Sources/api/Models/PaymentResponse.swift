//
//  PaymentResponse.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PaymentResponse: Mappable {
    private(set) var transactionId: String?
    private(set) var md: String?
    private(set) var paReq: String?
    private(set) var acsUrl: String?
    private(set) var message: String?
    private(set) var statusCode: String?
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
        statusCode <- map["statusCode"]
        cardToken <- map["cardToken"]
        partnerRedirectUrl <- map["partnerRedirectUrl"]
    }
}
