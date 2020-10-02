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
    
    func offlineRegister(with phoneNumber: String, name: String?, completion: HTTPRequestCompletion<[Layout]>?) {
        let request = HTTPRequest(resource: .offlineRegister, method: .post, parameters: ["phoneNumber" : phoneNumber, "name" : name ?? ""])
        makeArrayRequest(request, completion: completion)
    }
    
//    public func charge(cardCryptogramPacket: String, cardHolderName: String?, email: String?, amount: String, currency: Currency = .ruble, completion: @escaping HTTPRequestCompletion<TransactionResponse>) {
//        self.threeDsCompletion = nil
//        
//        let parameters: Parameters = [
//            "Amount" : "\(amount)", // Сумма платежа (Обязательный)
//            "Currency" : currency.rawValue, // Валюта (Обязательный)
//            "IpAddress" : "", // IP адрес плательщика (Обязательный)
//            "Name" : cardHolderName ?? defaultCardHolderName, // Имя держателя карты в латинице (Обязательный для всех платежей кроме Apple Pay и Google Pay)
//            "CardCryptogramPacket" : cardCryptogramPacket, // Криптограмма платежных данных (Обязательный)
//            "Email" : email ?? "" // E-mail, на который будет отправлена квитанция об оплате
//        ]
//
//        let request = HTTPRequest(resource: .charge, method: .post, parameters: parameters)
//        makeObjectRequest(request, completion: completion)
//    }
//    
//    public func auth(cardCryptogramPacket: String, cardHolderName: String?, email: String?, amount: String, currency: Currency = .ruble, completion: @escaping HTTPRequestCompletion<TransactionResponse>) {
//        self.threeDsCompletion = nil
//        
//        let parameters: Parameters = [
//            "Amount" : "\(amount)", // Сумма платежа (Обязательный)
//            "Currency" : currency.rawValue, // Валюта (Обязательный)
//            "IpAddress" : "",
//            "Name" : cardHolderName ?? defaultCardHolderName, // Имя держателя карты в латинице (Обязательный для всех платежей кроме Apple Pay и Google Pay)
//            "CardCryptogramPacket" : cardCryptogramPacket, // Криптограмма платежных данных (Обязательный)
//            "Email" : email ?? "" // E-mail, на который будет отправлена квитанция об оплате
//        ]
//        
//        let request = HTTPRequest(resource: .auth, method: .post, parameters: parameters)
//        makeObjectRequest(request, completion: completion)
//    }
//    
//    public func post3ds(transactionId: String, threeDsCallbackId: String, paRes: String, completion: @escaping (_ result: ThreeDsResponse) -> ()) {
//        let mdParams = ["TransactionId": transactionId,
//                        "ThreeDsCallbackId": threeDsCallbackId,
//                        "SuccessUrl": self.threeDsSuccessURL,
//                        "FailUrl": self.threeDsFailURL]
//        if let mdParamsData = try? JSONSerialization.data(withJSONObject: mdParams, options: .sortedKeys), let mdParamsStr = String.init(data: mdParamsData, encoding: .utf8) {
//            let parameters: Parameters = [
//                "MD" : mdParamsStr,
//                "PaRes" : paRes
//            ]
//            
//            self.threeDsCompletion = completion
//            
//            let completion: HTTPRequestCompletion<TransactionResponse> = { r, e in }
//            
//            let request = HTTPRequest(resource: .post3ds, method: .post, parameters: parameters)
//            makeObjectRequest(request, completion: completion)
//        } else {
//            completion(ThreeDsResponse.init(success: false, cardHolderMessage: ""))
//        }
//    }
//    
//    private class ThreeDsRedirectHandler: RedirectHandler {
//        private let threeDsSuccessURL: String
//        private let threeDsFailURL: String
//        var api: CloudtipsApi?
//        
//        init(threeDsSuccessURL: String, threeDsFailURL: String) {
//            self.threeDsSuccessURL = threeDsSuccessURL
//            self.threeDsFailURL = threeDsFailURL
//        }
//        
//        public func task(_ task: URLSessionTask, willBeRedirectedTo request: URLRequest, for response: HTTPURLResponse, completion: @escaping (URLRequest?) -> Void) {
//            if let url = request.url {
//                let items = url.absoluteString.split(separator: "&").filter { $0.contains("CardHolderMessage")}
//                var message: String? = nil
//                if !items.isEmpty, let params = items.first?.split(separator: "="), params.count == 2 {
//                    message = String(params[1]).removingPercentEncoding
//                }
//                
//                if url.absoluteString.starts(with: threeDsSuccessURL) {
//                    self.threeDsFinished(with: true, message: message)
//                    completion(nil)
//                } else if url.absoluteString.starts(with: threeDsFailURL) {
//                    self.threeDsFinished(with: false, message: message)
//                    completion(nil)
//                } else {
//                    completion(request)
//                }
//            } else {
//                completion(request)
//            }
//        }
//        
//        private func threeDsFinished(with success: Bool, message: String?) {
//            DispatchQueue.main.async {
//                let result = ThreeDsResponse.init(success: success, cardHolderMessage: message)
//                self.api?.threeDsCompletion?(result)
//            }
//        }
//    }
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
