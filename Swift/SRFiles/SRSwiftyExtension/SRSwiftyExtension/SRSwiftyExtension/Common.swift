//
//  Common.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/13.
//  Copyright © 2019 SR. All rights reserved.
//

import Foundation

protocol InstanceEquatable: class, Equatable { }

extension InstanceEquatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
}

//extension Enemy: InstanceEquatable { }
//
//func testDestroyingEnemy() {
//    player.attack(enemy)
//    XCTAssertTrue(player.destroyedEnemies.contains(enemy))
//}
