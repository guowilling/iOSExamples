
#import <UIKit/UIKit.h>

@interface ElegantCircleProgress : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;

@property (nonatomic, assign) CGFloat progress;

@end
