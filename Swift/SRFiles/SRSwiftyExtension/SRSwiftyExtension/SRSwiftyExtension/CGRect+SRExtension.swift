
import CoreGraphics

public extension CGRect {
    
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    
    var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
}
