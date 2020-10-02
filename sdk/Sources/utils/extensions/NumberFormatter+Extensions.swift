//
//  NumberFormatter+Extensions.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 01.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public class func currencyString(from number: NSNumber, withDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.init(identifier: "ru_RU")
        formatter.maximumFractionDigits = withDigits
        return formatter.string(from: number) ?? "0"
    }
}
