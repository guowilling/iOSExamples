//
//  NSObject+SRExtension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2018/11/29.
//  Copyright © 2018年 SR. All rights reserved.
//

import Foundation

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
