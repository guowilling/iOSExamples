
import UIKit

public extension UIDevice {
    
    /// 是否是 iPhone
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
    
    /// 屏幕方向
    public class var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
}
