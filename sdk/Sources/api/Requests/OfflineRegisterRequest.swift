//
//  OfflineRegisterRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import CloudpaymentsNetworking

class OfflineRegisterRequest: BaseRequest, CloudpaymentsRequestType {
    typealias ResponseType = [Layout]
    
    var data: CloudpaymentsRequest {
        return CloudpaymentsRequest(path: HTTPResource.offlineRegister.asURL(), method: .post, params: params, headers: headers)
    }
}
