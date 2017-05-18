
#import "MBProgressHUD.h"

@interface MBProgressHUD (SR)

#pragma mark - Show HUD

/// Only Text
+ (MBProgressHUD *)sr_showMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view;

/// Indeterminate Icon and Test
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view;

/// Success Icon and Text
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/// Error Icon and Text
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/// Info Icon and Text
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/// Icon and Text
+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

#pragma mark - Hide HUD

+ (void)sr_hideHUD;
+ (void)sr_hideHUDForView:(UIView *)view;
+ (void)sr_hideHUDForView:(UIView *)view afterDelay:(NSTimeInterval)delay;

@end
