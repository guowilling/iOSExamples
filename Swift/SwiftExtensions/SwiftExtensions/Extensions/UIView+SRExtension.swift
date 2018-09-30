//
//  UIView+SRFrame.swift
//  SwiftExtensions
//
//  Created by 郭伟林 on 2018/9/28.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

/// Frame
extension UIView {
    public var sr_x: CGFloat {
        get { return frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    public var sr_y: CGFloat {
        get { return frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    public var sr_width: CGFloat {
        get { return frame.size.width }
        set { frame.size.width = newValue }
    }
    
    public var sr_height: CGFloat {
        get { return frame.size.height }
        set { frame.size.height = newValue }
    }
    
    public var sr_top: CGFloat {
        get { return sr_y }
        set { sr_y = newValue }
    }
    
    public var sr_left: CGFloat {
        get { return sr_x }
        set { sr_x = newValue }
    }
    
    public var sr_bottom: CGFloat {
        get { return sr_y + sr_height }
        set { sr_y = newValue - sr_height }
    }
    
    public var sr_right: CGFloat {
        get { return sr_x + sr_width }
        set { sr_x = newValue - sr_width }
    }
}

public extension UIView {
    /// firstViewController
    var firstViewController: UIViewController? {
        get {
            for view in sequence(first: self.superview, next: { $0?.superview }) {
                if let responder = view?.next, responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
            return nil
        }
    }
    
    /// round
    public func round(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) {
        self.round(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    
    public func round(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) {
        guard let maskLayer = self.layer.mask else {
            let rect = self.bounds
            let bezierPath = UIBezierPath(roundedRect: rect,
                                          byRoundingCorners: byRoundingCorners,
                                          cornerRadii: cornerRadii)
            defer {
                bezierPath.close()
            }
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezierPath.cgPath
            self.layer.mask = shapeLayer
            self.layer.masksToBounds = true
            return
        }
    }
    
    /// snapshot
    public var snapshotImage: UIImage? {
        return snapshot()
    }
    
    public func snapshot(rect: CGRect = CGRect.zero, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        var snapRect = rect
        if __CGSizeEqualToSize(rect.size, CGSize.zero) {
            snapRect = calculateSnapshotRect()
        }
        UIGraphicsBeginImageContextWithOptions(snapRect.size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        self.drawHierarchy(in: snapRect, afterScreenUpdates: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func calculateSnapshotRect() -> CGRect {
        var targetRect = self.bounds
        if let scrollView = self as? UIScrollView {
            let contentInset = scrollView.contentInset
            let contentSize = scrollView.contentSize
            targetRect.origin.x = contentInset.left
            targetRect.origin.y = contentInset.top
            targetRect.size.width = targetRect.size.width  - contentInset.left - contentInset.right > contentSize.width ? targetRect.size.width  - contentInset.left - contentInset.right : contentSize.width
            targetRect.size.height = targetRect.size.height - contentInset.top - contentInset.bottom > contentSize.height ? targetRect.size.height  - contentInset.top - contentInset.bottom : contentSize.height
        }
        return targetRect
    }
}
