//
//  Font+Extension.swift
//  SRSwiftyExtension
//
//  Created by 郭伟林 on 2019/5/24.
//  Copyright © 2019 SR. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum FontSize: CGFloat {
        case small = 12
        case medium = 17
        case large = 22
    }
    
    static func light(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
    
    static func regular(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    static func bold(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func semiBold(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
}
