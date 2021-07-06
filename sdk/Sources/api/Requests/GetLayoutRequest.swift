//
//  GetLayoutRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import CloudpaymentsNetworking

class GetLayoutRequest: BaseRequest, CloudpaymentsRequestType {
    typealias ResponseType = [Layout]
    
    private let phoneNumber: String
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init()
    }
    
    var data: CloudpaymentsRequest {
        return CloudpaymentsRequest(path: HTTPResource.getLayout(phoneNumber).asURL(), method: .get, params: params, headers: headers)
    }
}
