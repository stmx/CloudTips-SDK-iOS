//
//  CapthcaVerifyResponse.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 17.12.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import ObjectMapper

public struct CaptchaVerifyResponse: Mappable {
    private(set) var status: String?
    private(set) var token: String?
    private(set) var title: String?
    private(set) var detail: String?
    
    public init?(map: Map) {
        
    }

    public mutating func mapping(map: Map) {
        status <- map["status"]
        token <- map["token"]
        title <- map["title"]
        detail <- map["detail"]
    }
}
