//
//  UIWindow+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)

- (void)switchRootViewController {
    
    NSString *bundelIDStringKey = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:bundelIDStringKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[bundelIDStringKey];
    if ([lastVersion isEqualToString:currentVersion]) {
        //self.rootViewController = [[SRTabBarController alloc] init];
    } else {
        //self.rootViewController = [[SRNewFeatureViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:bundelIDStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
