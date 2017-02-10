
#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setSr_x:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)sr_x
{
    return self.frame.origin.x;
}

- (void)setSr_y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)sr_y
{
    return self.frame.origin.y;
}

- (void)setSr_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)sr_centerX
{
    return self.center.x;
}

- (void)setSr_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)sr_centerY
{
    return self.center.y;
}

- (void)setSr_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)sr_width
{
    return self.frame.size.width;
}

- (void)setSr_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)sr_height
{
    return self.frame.size.height;
}


- (void)setSr_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)sr_size
{
    return self.frame.size;
}

- (void)setSr_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)sr_origin
{
    return self.frame.origin;
}

@end
