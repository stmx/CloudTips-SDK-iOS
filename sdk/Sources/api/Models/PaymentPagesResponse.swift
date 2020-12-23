//
//  PaymentPagesResponse.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 23.12.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import ObjectMapper

public struct PaymentPagesResponse: Mappable {
    private(set) var id: String?
    private(set) var layoutId: String?
    private(set) var url: String?
    private(set) var title: String?
    private(set) var backgroundUrl: String?
    private(set) var amount: AmountSettings?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        layoutId <- map["layoutId"]
        id <- map["id"]
        url <- map["url"]
        title <- map["title"]
        backgroundUrl <- map["backgroundUrl"]
        amount <- map["amount"]
    }
}

public struct AmountSettings: Mappable {
    private(set) var constraints: [AmountConstraint]?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        constraints <- map["constraints"]
    }
    
    func getMinAmount() -> Double? {
        return self.constraints?.filter { $0.type == "Minimal" }.first?.value
    }
    
    func getMaxAmount() -> Double? {
        return self.constraints?.filter { $0.type == "Maximal" }.first?.value
    }
}

public struct AmountConstraint: Mappable {
    private(set) var type: String?
    private(set) var currency: String?
    private(set) var value: Double?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        type <- map["type"]
        currency <- map["currency"]
        value <- map["value"]
    }
}
