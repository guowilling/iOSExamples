
#import <UIKit/UIKit.h>

@interface GradientProgressView : UIView

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, assign) CGFloat progress;

- (void)startAnimating;

- (void)stopAnimating;

@end
