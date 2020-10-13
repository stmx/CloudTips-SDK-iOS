//
//  PaymentData.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation
import Cloudpayments

class PaymentData {
    let layoutId: String
    let amount: NSNumber
    let comment: String?
    let currency: Currency
    
    init(layoutId: String, amount: NSNumber, comment: String?, currency: Currency = .ruble) {
        self.layoutId = layoutId
        self.comment = comment
        self.amount = amount
        self.currency = currency
    }
}
