//
//  CloudtipsApi.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 29.09.2020.
//  Copyright © 2020 Cloudtips. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public class CloudtipsApi {
    private let defaultCardHolderName = "Cloudtips SDK"
    
    private let threeDsSuccessURL = "https://cloudtips.ru/success"
    private let threeDsFailURL = "https://cloudtips.ru/fail"
    
    private let session: Session = Session.default
    
//    private var threeDsCompletion: ((_ result: ThreeDsResponse) -> ())?
    
    lazy var redirectHandler = self
    
    func getLayout(by phoneNumber: String, completion: HTTPRequestCompletion<[Layout]>?) {
        let request = HTTPRequest(resource: .getLayout(phoneNumber))
        makeArrayRequest(request, completion: completion)
    }
    
    func getUserProfile(by layoutId: String, completion: HTTPRequestCompletion<Profile>?) {
        let request = HTTPRequest(resource: .getUser(layoutId))
        makeObjectRequest(request, completion: completion)
    }
    
    func offlineRegister(with phoneNumber: String, name: String?, agentCode: String?, completion: HTTPRequestCompletion<[Layout]>?) {
        let request = HTTPRequest(resource: .offlineRegister, method: .post, parameters: ["phoneNumber" : phoneNumber, "name" : name ?? "", "agentCode" : agentCode ?? ""])
        makeArrayRequest(request, completion: completion)
    }
    
    func getPublicId(with layoutId: String, completion: HTTPRequestCompletion<PublicIdResponse>?) {
        let request = HTTPRequest(resource: .getPublicId, method: .post, parameters: ["layoutId": layoutId])
        makeObjectRequest(request, completion: completion)
    }
    
    func auth(with paymentData: PaymentData, cryptogram: String, captchaToken: String, completion: HTTPRequestCompletion<PaymentResponse>?) {
        let params: [String: Any] =
            ["cardholderName": "Cloudtips SDK",
             "cardCryptogramPacket": cryptogram,
             "amount": paymentData.amount,
             "currency": paymentData.currency.rawValue,
             "comment": paymentData.comment ?? "",
             "layoutId": paymentData.layoutId,
             "captchaVerificationToken": captchaToken]
        
        let request = HTTPRequest(resource: .authPayment, method: .post, parameters: params)
        makeObjectRequest(request, completion: completion)
    }
    
    public func post3ds(md: String, paRes: String, completion: HTTPRequestCompletion<PaymentResponse>?) {
        let parameters = ["md": md,
                          "paRes": paRes]
        let request = HTTPRequest(resource: .post3ds, method: .post, parameters: parameters)
        makeObjectRequest(request, completion: completion)
    }
    
    func verifyCaptcha(version: Int, token: String, amount: String, layoutId: String, completion: HTTPRequestCompletion<CaptchaVerifyResponse>?) {
        let parameters = ["version": version,
                          "token": token,
                          "amount": amount,
                          "layoutId": layoutId] as [String : Any]
        let request = HTTPRequest(resource: .captchaVerify, method: .post, parameters: parameters)
        makeObjectRequest(request, completion: completion)
    }
    
    func getPaymentPages(by layoutId: String, completion: HTTPRequestCompletion<PaymentPagesResponse>?) {
        let request = HTTPRequest(resource: .getPaymentPages(layoutId))
        makeObjectRequest(request, completion: completion)
    }
}


// MARK: - Internal methods

extension CloudtipsApi {
    
    func makeObjectRequest<T: BaseMappable>(_ request: HTTPRequest, completion: HTTPRequestCompletion<T>?) {
        let url = (try? request.resource.asURL())?.absoluteString ?? ""
        
        print("--------------------------")
        print("sending request: \(url)")
        print("parameters: \(request.parameters as NSDictionary?)")
        print("--------------------------")
        
        validatedDataRequest(from: request).responseObject { (dataResponse) in
//            if let data = dataResponse.data, let dataStr = String.init(data: data, encoding: .utf8) {
//                print("--------------------------")
//                print("response for (\(url): \(dataStr)")
//                print("--------------------------")
//            }
            
            completion?(dataResponse.value, dataResponse.error)
        }
    }
    
    func makeArrayRequest<T: BaseMappable>(_ request: HTTPRequest, completion: HTTPRequestCompletion<[T]>?) {
        let url = (try? request.resource.asURL())?.absoluteString ?? ""
        
        print("--------------------------")
        print("sending request: \(url)")
        print("parameters: \(request.parameters as NSDictionary?)")
        print("--------------------------")
        
        validatedDataRequest(from: request).responseArray(completionHandler: { (dataResponse) in
//            if let data = dataResponse.data, let dataStr = String.init(data: data, encoding: .utf8) {
//                print("--------------------------")
//                print("response for (\(url): \(dataStr)")
//                print("--------------------------")
//            }
            
            completion?(dataResponse.value, dataResponse.error)
        })
    }
}

// MARK: - Private methods

private extension CloudtipsApi {
    
    func validatedDataRequest(from httpRequest: HTTPRequest) -> DataRequest {
        var encoding: ParameterEncoding = JSONEncoding.default
        if httpRequest.method == .get {
            encoding = URLEncoding.default
        }
        return session
            .request(httpRequest.resource,
                     method: httpRequest.method,
                     parameters: httpRequest.parameters,
                     encoding: encoding,
                     headers: httpRequest.headers)
            .validate()
    }
}
