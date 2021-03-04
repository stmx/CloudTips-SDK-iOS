//
//  TipsConfiguration.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 09.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

public class TipsConfiguration {
    internal let phoneNumber: String
    internal let userName: String?
    internal let agentCode: String?
    internal private(set) var applePayMerchantId: String = ""
    
    var layout: Layout?
    var profile: Profile?
    
    public init(phoneNumber: String, userName: String?, partner: String? = nil) {
        self.phoneNumber = phoneNumber
        self.userName = userName
        self.agentCode = partner
    }
    
    public func setApplePayMerchantId(_ merchantId: String) {
        self.applePayMerchantId = merchantId
    }
}
