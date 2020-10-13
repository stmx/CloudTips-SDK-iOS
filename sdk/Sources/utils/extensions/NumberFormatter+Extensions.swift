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
    
    public class func currencyNumber(from string: String, withDigits: Int = 2) -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = withDigits
        if string.contains(",") {
            formatter.decimalSeparator = ","
        } else if string.contains(".") {
            formatter.decimalSeparator = "."
        }
        return formatter.number(from: string)
    }
}
