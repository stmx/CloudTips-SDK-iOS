//
//  PostThreeDsRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import CloudpaymentsNetworking

class PostThreeDsRequest: BaseRequest, CloudpaymentsRequestType {
    typealias ResponseType = PaymentResponse
    
    var data: CloudpaymentsRequest {
        return CloudpaymentsRequest(path: HTTPResource.post3ds.asURL(), method: .post, params: params, headers: headers)
    }
}
