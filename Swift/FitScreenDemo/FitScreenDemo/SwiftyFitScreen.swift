//
//  SwiftyFitScreen.swift
//  FitScreenDemo
//
//  Created by Willing Guo on 2018/10/18.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

public final class SwiftyFitSize {
    static let shared = SwiftyFitSize()
    
    private init() { }
    
    /// default is 375
    private var referenceW: CGFloat = 375
    
    public static func reference(width: CGFloat) {
        SwiftyFitSize.shared.referenceW = width
    }
    
    fileprivate func fitSize(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width / referenceW * value
    }
}

postfix operator ~

public postfix func ~ (value: CGFloat) -> CGFloat {
    return SwiftyFitSize.shared.fitSize(value)
}

public postfix func ~ (font: UIFont) -> UIFont {
    return UIFont(name: font.fontName, size: font.pointSize~) ?? font
}

public postfix func ~ (value: Int) -> CGFloat {
    return CGFloat(value)~
}

public postfix func ~ (value: Float) -> CGFloat {
    return CGFloat(value)~
}

public postfix func ~ (value: CGPoint) -> CGPoint {
    return CGPoint(x: value.x~, y: value.y~)
}

public postfix func ~ (value: CGSize) -> CGSize {
    return CGSize(width: value.width~, height: value.height~)
}

public postfix func ~ (value: CGRect) -> CGRect {
    return CGRect(x: value.origin.x~,
                  y: value.origin.y~,
                  width: value.size.width~,
                  height: value.size.height~)
}

public postfix func ~ (value: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: value.top~,
                             left: value.left~,
                             bottom: value.bottom~,
                             right: value.right~)
}
