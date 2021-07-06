//
//  BaseRequest.swift
//  Cloudtips-SDK-iOS
//
//  Created by Sergey Iskhakov on 02.07.2021.
//  Copyright © 2021 Cloudtips. All rights reserved.
//

import Foundation

open class BaseRequest {
    var params: [String: Any?]
    var headers: [String: String]
    
    public init(params: [String: Any?] = [:],
                headers: [String: String] = [:]) {
        self.params = params
        self.headers = headers
    }
}
