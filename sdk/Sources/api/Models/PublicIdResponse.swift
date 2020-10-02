//
//  PublicIdResponse.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PublicIdResponse: Mappable {
    private(set) var publicId: String?
    
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        publicId <- map["publicId"]
    }
}

