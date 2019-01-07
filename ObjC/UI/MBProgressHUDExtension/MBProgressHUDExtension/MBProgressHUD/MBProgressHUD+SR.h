
#import "MBProgressHUD.h"

@interface MBProgressHUD (SR)

#pragma mark - Show HUD

/// Just Text
+ (MBProgressHUD *)sr_showMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/// Indeterminate Icon And Test
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view;

/**
 Show an indeterminate hud on grace time condition.
 
 @param graceTime default is 0.5, if graceTime <= 0 or graceTime >= 3 will be the default value.
 */
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message graceTime:(NSTimeInterval)graceTime;
+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message graceTime:(NSTimeInterval)graceTime onView:(UIView *)view;

/// Success Icon And Test
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

/// Error Icon And Test
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

// Info Icon And Test
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message;
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

// Icon
+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view;
+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

#pragma mark - Hide HUD

+ (void)sr_hideHUD;
+ (void)sr_hideHUDForView:(UIView *)view;
+ (void)sr_hideHUDAfterDelay:(NSTimeInterval)delay;
+ (void)sr_hideHUDForView:(UIView *)view afterDelay:(NSTimeInterval)delay;

@end
