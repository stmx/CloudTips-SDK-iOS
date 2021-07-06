//
//  GetPublicIdRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import CloudpaymentsNetworking

class GetPublicIdRequest: BaseRequest, CloudpaymentsRequestType {
    typealias ResponseType = PublicIdResponse
    
    var data: CloudpaymentsRequest {
        return CloudpaymentsRequest(path: HTTPResource.getPublicId.asURL(), method: .post, params: params, headers: headers)
    }
}

