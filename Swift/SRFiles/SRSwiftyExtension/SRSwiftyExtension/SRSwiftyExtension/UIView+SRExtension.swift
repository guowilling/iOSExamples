
import UIKit

public extension UIView {
    
    /// round
    func round(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) {
        self.round(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    
    func round(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) {
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
    
    /// snapshot
    var snapshotImage: UIImage? {
        return snapshot()
    }
    
    func snapshot(rect: CGRect = CGRect.zero, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
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
