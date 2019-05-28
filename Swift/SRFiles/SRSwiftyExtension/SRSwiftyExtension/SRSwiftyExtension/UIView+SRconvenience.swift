//
//  UIView+SRCon.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/27.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

extension UILabel {
    convenience public init(
        text: String?,
        font: UIFont? = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = .black,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1)
    {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

extension UIButton {
    
    convenience public init(
        title: String?,
        titleColor: UIColor?,
        font: UIFont = .systemFont(ofSize: 17),
        target: Any? = nil,
        action: Selector? = nil)
    {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    convenience public init(
        image: UIImage?,
        target: Any? = nil,
        action: Selector? = nil)
    {
        self.init(type: .custom)
        setImage(image, for: .normal)
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
}

extension UITextField {
    public convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
}
