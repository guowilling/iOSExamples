//
//  SRCommonExtension.swift
//  SwiftExtensions
//
//  Created by 郭伟林 on 2018/9/28.
//  Copyright © 2018年 SR. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public extension CGRect {
    public var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    public var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    public var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    
    public var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
}

public extension UIScreen {
    public class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    public class var width: CGFloat {
        return size.width
    }
    
    public class var height: CGFloat {
        return size.height
    }
}

public extension UIDevice {
    public class var isIphone: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    }
    
    /// 4 英寸, 5/5S/5C
    public class var iPhone_568: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) == 568.0
    }
    
    public class var iPhone_568_or_less: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) <= 568.0
    }
    
    /// 4.7 英寸, 6/6S/7/8
    public class var iPhone_667: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) == 667.0
    }
    
    public class var iPhone_667_or_less: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) <= 667.0
    }
    
    /// 5.5 英寸, 6P/6SP/7P/8P
    public class var iPhone_736: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) == 736.0
    }
    
    public class var iPhone_736_or_less: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) <= 736.0
    }
    
    /// 5.8 英寸, X
    public class var iPhone_818: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) == 812.0
    }
    
    public class var iPhone_818_or_less: Bool {
        return isIphone && max(UIScreen.width, UIScreen.height) <= 812.0
    }
    
    public class var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
}
