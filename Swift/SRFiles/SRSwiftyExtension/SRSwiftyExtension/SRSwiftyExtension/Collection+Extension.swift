//
//  Collection+Extension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/13.
//  Copyright © 2019 SR. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func after(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 < self.count {
            return self[index + 1]
        }
        return nil
    }
    
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

extension Dictionary {
    mutating func value(for key: Key, orAdd valueClosure: @autoclosure () -> Value) -> Value {
        if let value = self[key] {
            return value
        }
        
        let value = valueClosure()
        self[key] = value
        return value
    }
}
