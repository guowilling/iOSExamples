//
//  Digital.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/24.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

/// 角度转弧度
func degreesToRadians (_ value: CGFloat) -> CGFloat {
    return value * .pi / 180.0
}

// 弧度转角度
func radiansToDegrees (_ value: CGFloat) -> CGFloat {
    return value * 180.0 / .pi
}
