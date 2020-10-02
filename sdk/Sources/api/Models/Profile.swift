//
//  Profile.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 30.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import ObjectMapper

struct Profile: Mappable {
    private(set) var name: String?
    private(set) var photoUrl: String?
    private(set) var receiverType: Int?
    private(set) var purposeText: String?
    private(set) var successPageText: String?
    
//    "receiverText": {
//      "ru": [
//        {
//          "payPage": "string",
//          "successPage": "string"
//        }
//      ],
//      "en": [
//        {
//          "payPage": "string",
//          "successPage": "string"
//        }
//      ]
//    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        photoUrl <- map["photoUrl"]
        receiverType <- map["receiverType"]
        
        if let textArray = (map.JSON["receiverText"] as? [String: Any])?["ru"] as? [[String: Any]], let first = textArray.first {
            purposeText = first["payPage"] as? String
            successPageText = first["successPage"] as? String
        }
    }
}
