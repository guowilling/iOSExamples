//
//  UIViewController+Extension.m
//  CategoriesDemo
//
//  Created by 郭伟林 on 2018/3/1.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

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
