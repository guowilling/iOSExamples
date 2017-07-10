//
//  UIViewController+FindNavigationController.m
//  LoadAdvertisementDemo
//
//  Created by 郭伟林 on 2017/7/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIViewController+FindNavigationController.h"

@implementation UIViewController (FindNavigationController)

- (UINavigationController *)findNavigationController {
    
    UINavigationController *navC = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        navC = (id)self;
    } else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            navC = [((UITabBarController*)self).selectedViewController findNavigationController];
        } else {
            navC = self.navigationController;
        }
    }
    return navC;
}

@end
