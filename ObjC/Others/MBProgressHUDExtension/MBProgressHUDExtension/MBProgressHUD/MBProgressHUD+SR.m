
#import "MBProgressHUD+SR.h"

static const CGFloat kMessageHUDLayerCornerRadius = 5;
static const CGFloat kIconHUDLayerCornerRadius = 10;

@implementation MBProgressHUD (SR)

#pragma mark - Only Text

+ (MBProgressHUD *)sr_showMessage:(NSString *)message {
    return [self sr_showMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view {
    return [self sr_showMessage:message onView:view completionBlock:nil];
}

+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    view = view ?: [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.adjustsFontSizeToFitWidth = YES;
    hud.margin = 12;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.layer.cornerRadius = kMessageHUDLayerCornerRadius;
    hud.completionBlock = completionBlock;
    return hud;
}

#pragma mark - UIActivityIndicatorView And Text

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message {
    return [self sr_showIndeterminateWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view {
    return [self sr_showIndeterminateWithMessage:message onView:view graceTime:0];
}

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view graceTime:(NSTimeInterval)graceTime {
    return [self sr_showIndeterminateWithMessage:message onView:view graceTime:graceTime completionBlock:nil];
}

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view graceTime:(NSTimeInterval)graceTime completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    view = view ?: [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize = CGSizeMake(120, 120);
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.adjustsFontSizeToFitWidth = YES;
    hud.margin = 15.0;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.layer.cornerRadius = kIconHUDLayerCornerRadius;
    if (graceTime <= 0 || graceTime >= 3) {
        hud.graceTime = 0.5;
    } else {
        hud.graceTime = graceTime;
    }
    hud.completionBlock = completionBlock;
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

#pragma mark - Success Icon And Text

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message {
    return [self sr_showSuccessWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view {
    return [self sr_showSuccessWithMessage:message onView:view completionBlock:nil];
}

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    return [self sr_showIconName:@"success.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Error Icon And Text

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message {
    return [self sr_showErrorWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view {
    return [self sr_showErrorWithMessage:message onView:view completionBlock:nil];
}

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    return [self sr_showIconName:@"error.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Info Icon And Text

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message {
    return [self sr_showInfoWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view {
    return [self sr_showInfoWithMessage:message onView:view completionBlock:nil];
}

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    return [self sr_showIconName:@"info.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Icon And Text

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName {
    return [self sr_showIconName:iconName message:nil];
}

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message {
    return [self sr_showIconName:iconName message:message onView:nil];
}

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view {
    return [self sr_showIconName:iconName message:message onView:view completionBlock:nil];
}

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    view = view ?: [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]];
    if (!image) {
        image = [UIImage imageNamed:iconName];
    }
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.minSize = CGSizeMake(120, 120);
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.adjustsFontSizeToFitWidth = YES;
    hud.margin = 15.0;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.layer.cornerRadius = kIconHUDLayerCornerRadius;
    hud.completionBlock = completionBlock;
    [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}

#pragma mark - Hide HUD

+ (void)sr_hideHUD {
    [self sr_hideHUDForView:nil];
}

+ (void)sr_hideHUDForView:(UIView *)view {
    [self sr_hideHUDForView:view afterDelay:0];
}

+ (void)sr_hideHUDForView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    view = view ?: [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [self HUDForView:view];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

@end
