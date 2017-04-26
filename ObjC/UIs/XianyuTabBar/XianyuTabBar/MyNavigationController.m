//
//  MyNavigationController.m
//  XianyuTabBar
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "MyNavigationController.h"
#import "UIImage+Image.h"

#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

@interface MyNavigationController ()

@end

@implementation MyNavigationController

+ (void)initialize {
    
    {
        UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
        [barButtonItemAppearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
    
    {
        UINavigationBar *navigationBarAppearance = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
        [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        [navigationBarAppearance setTitleTextAttributes:attributes];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    return [super pushViewController:viewController animated:animated];
}

@end
