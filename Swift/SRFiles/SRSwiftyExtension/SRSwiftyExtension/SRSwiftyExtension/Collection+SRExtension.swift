//
//  Collection+SRExtension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/4/23.
//  Copyright © 2019 SR. All rights reserved.
//

import Foundation

extension Collection {
    
    /// return the element at the specified index if it is within bounds, otherwise nil.
    ///
    /// - Parameter index: specified index
    ///
    /// let cars = ["Lexus", "Ford", "Volvo", "Toyota", "Opel"]
    /// let selectedCar1 = cars[safe: 3] // Toyota
    /// let selectedCar2 = cars[safe: 6] // not crash, but nil
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
