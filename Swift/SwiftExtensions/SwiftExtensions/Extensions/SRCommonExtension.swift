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
    public class var sr_size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    public class var sr_width: CGFloat {
        return sr_size.width
    }
    
    public class var sr_height: CGFloat {
        return sr_size.height
    }
    
    static var statusBarHeight: CGFloat {
        get {
            return UIDevice.is_iPhone_812 ? 44 : 20
        }
    }
    
    static var navBarHeight:CGFloat {
        get {
            return UIDevice.is_iPhone_812 ? 88 : 64
        }
    }
    
    static var tabBarHeight:CGFloat {
        get {
            return UIDevice.is_iPhone_812 ? 83 : 49
        }
    }
    
    static var homeIndicatorHeight: CGFloat {
        get {
            return UIDevice.is_iPhone_812 ? 34 : 0
        }
    }
}

public extension UIDevice {
    public class var isIphone: Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    }
    
    /// 4 英寸, 5/5S/5C
    public class var is_iPhone_568: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) == 568.0
    }
    
    public class var is_iPhone_568_or_less: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) <= 568.0
    }
    
    /// 4.7 英寸, 6/6S/7/8
    public class var is_iPhone_667: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) == 667.0
    }
    
    public class var is_iPhone_667_or_less: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) <= 667.0
    }
    
    /// 5.5 英寸, 6P/6SP/7P/8P
    public class var is_iPhone_736: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) == 736.0
    }
    
    public class var is_iPhone_736_or_less: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) <= 736.0
    }
    
    /// 5.8 英寸, X
    public class var is_iPhone_812: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) == 812.0
    }
    
    public class var is_iPhone_812_or_less: Bool {
        return isIphone && max(UIScreen.sr_width, UIScreen.sr_height) <= 812.0
    }
    
    public class var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
}
