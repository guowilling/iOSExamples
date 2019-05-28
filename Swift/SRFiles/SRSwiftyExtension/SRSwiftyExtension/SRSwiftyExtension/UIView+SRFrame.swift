
import UIKit

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
    
    /**
     * Frame of the view relative to the app window.
     */
    var absoluteFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
