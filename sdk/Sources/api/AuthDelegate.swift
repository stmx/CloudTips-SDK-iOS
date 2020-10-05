//
//  AuthDelegate.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 05.10.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Foundation

protocol AuthDelegate {
    func getPublicId(with layoutId: String, completion: @escaping (_ publicId: String?, _ error: Error?) -> ())
    func auth(with paymentData: PaymentData, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ())
//    func post3ds()
}

extension AuthDelegate where Self: UIViewController {
    func getPublicId(with layoutId: String, completion: @escaping (_ publicId: String?, _ error: Error?) -> ()) {
        CloudtipsApi().getPublicId(with: layoutId) { (response, error) in
            completion(response?.publicId, error)
        }
    }
    
    func auth(with paymentData: PaymentData, completion: @escaping (_ response: PaymentResponse?, _ error: Error?) -> ()) {
        CloudtipsApi().auth(with: paymentData) { (response, error) in
            completion(response, error)
        }
    }
}
