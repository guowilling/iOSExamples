//
//  MBProgressHUD+SR.m
//
//  Created by 郭伟林 on 16/6/16.
//  Copyright © 2016年 again. All rights reserved.
//

#import "MBProgressHUD+SR.h"

@implementation MBProgressHUD (SR)

#pragma mark - Show HUD

#pragma mark - Only Test

+ (MBProgressHUD *)sr_showMessage:(NSString *)message {
    
    return [self sr_showMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:17];
    hud.margin = 12;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor blackColor];
    hud.bezelView.backgroundColor = [UIColor grayColor];
    hud.bezelView.layer.cornerRadius = 20;
    hud.userInteractionEnabled = NO;
    return hud;
}

#pragma mark - UIActivityIndicatorView and Text

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message {
    
    return [self sr_showIndeterminateWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:17];
    hud.minSize = CGSizeMake(120, 120);
    hud.margin = 15.0;
    hud.contentColor = [UIColor blackColor];
    hud.bezelView.backgroundColor = [UIColor grayColor];
    hud.bezelView.layer.cornerRadius = 20;
    //hud.dimBackground = YES;
    //hud.backgroundColor = [UIColor colorWithWhite:0.f alpha:.2f];
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma mark - Success Icon and Text

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message {
    
    return [self sr_showSuccessWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view {
    
    return [self sr_showIconName:@"success.png" message:message onView:view];
}

+ (MBProgressHUD *)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    return [self sr_showIconName:@"success.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Error Icon and Text

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message {
    
    return [self sr_showErrorWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view {
    
    return [self sr_showIconName:@"error.png" message:message onView:view];
}

+ (MBProgressHUD *)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    return [self sr_showIconName:@"error.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Info Icon and Text

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message {
    
    return [self sr_showInfoWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view {
    
    return [self sr_showIconName:@"info.png" message:message onView:view];
}

+ (MBProgressHUD *)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    return [self sr_showIconName:@"info.png" message:message onView:view completionBlock:completionBlock];
}

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]];
    if (!image) {
        image = [UIImage imageNamed:iconName];
    }
    hud.customView = [[UIImageView alloc] initWithImage:image];

    hud.label.text = message;
    {
        hud.label.adjustsFontSizeToFitWidth = YES;
    }
    hud.label.font = [UIFont systemFontOfSize:17];
    hud.label.numberOfLines = 0;
    hud.minSize = CGSizeMake(120, 120);
    hud.margin = 15.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor blackColor];
    hud.bezelView.layer.cornerRadius = 20;
    hud.bezelView.backgroundColor = [UIColor grayColor];
    hud.userInteractionEnabled = NO; // Must! or it will block user's action in some situation.
    [hud hideAnimated:YES afterDelay:2.0];
    return hud;
}

#pragma mark - Icon and Text

+ (MBProgressHUD *)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    MBProgressHUD *hud = [self sr_showIconName:iconName message:message onView:view];
    hud.completionBlock = completionBlock;
    return hud;
}

#pragma mark - Hide HUD

+ (void)sr_hideHUD {
    
    [self sr_hideHUDForView:nil];
}

+ (void)sr_hideHUDForView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)sr_hideHUDForView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [self HUDForView:view];
    [hud hideAnimated:YES afterDelay:delay];
}

@end
