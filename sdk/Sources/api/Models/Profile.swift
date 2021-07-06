//
//  Profile.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 30.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

struct Profile {
    var name: String?
    var photoUrl: String?
    var purposeText: String?
    var successPageText: String?
    
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        name <- map["name"]
//        photoUrl <- map["photoUrl"]
//        receiverType <- map["receiverType"]
//
//        if let textArray = (map.JSON["receiverText"] as? [String: Any])?["ru"] as? [[String: Any]], let first = textArray.first {
//            purposeText = first["payPage"] as? String
//            successPageText = first["successPage"] as? String
//        }
//    }
}
