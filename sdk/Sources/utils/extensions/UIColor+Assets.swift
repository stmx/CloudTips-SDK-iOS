//
//  UIColor+Assets.swift
//  sdk
//
//  Created by Sergey Iskhakov on 18.09.2020.
//  Copyright © 2020 Cloudpayments. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public class var mainText: UIColor {
        return color(named: "mainText")
    }
    
    public class var waterBlue: UIColor {
        return color(named: "waterBlue")
    }
    
    public class var azure: UIColor {
        return color(named: "azure")
    }
    
    private class func color(named colorName: String) -> UIColor! {
        return UIColor.init(named: colorName, in: Bundle.mainSdk, compatibleWith: .none)
    }
}
