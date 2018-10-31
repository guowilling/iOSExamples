
import UIKit

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
