
#import <UIKit/UIKit.h>

@interface UIView (SRFrame)

@property (nonatomic, assign) CGFloat sr_x;
@property (nonatomic, assign) CGFloat sr_y;

@property (nonatomic, assign) CGFloat sr_width;
@property (nonatomic, assign) CGFloat sr_height;

@property (nonatomic, assign) CGPoint sr_origin;
@property (nonatomic, assign) CGSize  sr_size;

@property (nonatomic, assign) CGFloat sr_centerX;
@property (nonatomic, assign) CGFloat sr_centerY;

@property (nonatomic, assign) CGFloat sr_left;
@property (nonatomic, assign) CGFloat sr_right;

@property (nonatomic, assign) CGFloat sr_top;
@property (nonatomic, assign) CGFloat sr_bottom;

@end
