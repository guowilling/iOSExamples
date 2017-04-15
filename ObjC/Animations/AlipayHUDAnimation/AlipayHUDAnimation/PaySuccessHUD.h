
#import <UIKit/UIKit.h>

@interface PaySuccessHUD : UIView <CAAnimationDelegate>

- (void)show;

- (void)hide;

+ (PaySuccessHUD *)showIn:(UIView *)view;

+ (void)hideIn:(UIView *)view;

@end
