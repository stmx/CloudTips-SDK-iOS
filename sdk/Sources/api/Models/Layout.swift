//
//  Layout.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import ObjectMapper

public struct Layout: Mappable {
    private(set) var layoutId: String?
    private(set) var defaultLayout: Bool?
    private(set) var disabled: Bool?
    private(set) var title: String?
    private(set) var description: String?
    private(set) var text: String?
    private(set) var paymentLink: String?
    private(set) var backgroundId: String?
    private(set) var backgroundUrl: String?
    private(set) var qrLink: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        layoutId <- map["layoutId"]
        defaultLayout <- map["default"]
        disabled <- map["disabled"]
        title <- map["title"]
        description <- map["description"]
        text <- map["text"]
        paymentLink <- map["paymentLink"]
        backgroundId <- map["backgroundId"]
        backgroundUrl <- map["backgroundUrl"]
        qrLink <- map["qrLink"]
    }
}
