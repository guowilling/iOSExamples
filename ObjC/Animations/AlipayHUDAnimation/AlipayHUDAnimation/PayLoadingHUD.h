//
//  感谢原作者 mengxianliang: https://github.com/mengxianliang/XLPaymentHUD
//

#import <UIKit/UIKit.h>

@interface PayLoadingHUD : UIView

- (void)show;

- (void)hide;

+ (PayLoadingHUD *)showIn:(UIView *)view;

+ (void)hideIn:(UIView *)view;

@end
