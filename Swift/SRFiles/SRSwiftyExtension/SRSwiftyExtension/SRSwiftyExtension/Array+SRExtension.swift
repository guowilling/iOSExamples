//
//  Array+SRExtension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/4/23.
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
