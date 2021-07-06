//
//  CapthcaVerifyRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import CloudpaymentsNetworking

class CaptchaVerifyRequest: BaseRequest, CloudpaymentsRequestType {
    typealias ResponseType = CaptchaVerifyResponse
    
    var data: CloudpaymentsRequest {
        return CloudpaymentsRequest(path: HTTPResource.captchaVerify.asURL(), method: .post, params: params, headers: headers)
    }
}
