//
//  SRHTTPSessionManager.swift
//  AlamofireExtension
//
//  Created by 郭伟林 on 2019/3/12.
//  Copyright © 2019年 SR. All rights reserved.
//

import UIKit

class SRHTTPSessionManager: NSObject {
    
    let HOST = ""
    
    let sessionManager: SessionManager = SessionManager.default
    
    static let shared: SRHTTPSessionManager = {
        let manager = SRHTTPSessionManager()
        return manager
    }()
    
    public func request(
        URL: String,
        method: HTTPMethod = .post,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        successHandler: (([String: Any]) -> Void)? = nil,
        failureHandler: ((Error) -> Void)? = nil)
    {
        self.sessionManager.request(
            HOST + URL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: nil).validate().responseJSON { (dataResponse) in
                switch dataResponse.result {
                case .success(let value):
                    print(value)
                    if let json = value as? [String: Any] {
                        successHandler?(json)
                    }
                case .failure(let error):
                    print(error)
                    failureHandler?(error)
                }
        }
    }
}

extension SRHTTPSessionManager {
    
    public static func get(URL: String, parameters: [String: Any]? = nil, success: (([String: Any]) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        SRHTTPSessionManager.shared.request(URL: URL, method:.get, parameters: parameters, successHandler: success, failureHandler: failure);
    }
    
    public static func post(URL: String, parameters: [String: Any]? = nil, success: (([String: Any]) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        SRHTTPSessionManager.shared.request(URL: URL, method:.post, parameters: parameters, successHandler: success, failureHandler: failure);
    }
}
