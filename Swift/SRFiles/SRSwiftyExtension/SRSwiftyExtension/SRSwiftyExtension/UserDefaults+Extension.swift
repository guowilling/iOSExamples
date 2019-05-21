//
//  UserDefaults+Extension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/13.
//  Copyright © 2019 SR. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var completed: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
