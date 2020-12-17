//
//  AuthDelegate.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 05.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

protocol PaymentDelegate {
    func getPublicId(with layoutId: String, completion: @escaping (_ publicId: String?, _ error: Error?) -> ())
    func auth(with paymentData: PaymentData, cryptogram: String, captchaToken: String, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ())
    func post3ds(md: String, paRes: String, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ())
    func verifyCaptcha(version: Int, token: String, amount: String, layoutId: String, completion: @escaping (_ response: CaptchaVerifyResponse?, _ error: Error?) -> ())
}

extension PaymentDelegate where Self: UIViewController {
    func getPublicId(with layoutId: String, completion: @escaping (_ publicId: String?, _ error: Error?) -> ()) {
        CloudtipsApi().getPublicId(with: layoutId) { (response, error) in
            completion(response?.publicId, error)
        }
    }
    
    func auth(with paymentData: PaymentData, cryptogram: String, captchaToken: String, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ()) {
        CloudtipsApi().auth(with: paymentData, cryptogram: cryptogram, captchaToken: captchaToken) { (response, error) in
            completion(response, error)
        }
    }
    
    func post3ds(md: String, paRes: String, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ()) {
        CloudtipsApi().post3ds(md: md, paRes: paRes) { (response, error) in
            completion(response, error)
        }
    }
    
    func verifyCaptcha(version: Int, token: String, amount: String, layoutId: String, completion: @escaping (_ response: CaptchaVerifyResponse?, _ error: Error?) -> ()) {
        CloudtipsApi().verifyCaptcha(version: version, token: token, amount: amount, layoutId: layoutId) { (response, error) in
            completion(response, error)
        }
    }
}
