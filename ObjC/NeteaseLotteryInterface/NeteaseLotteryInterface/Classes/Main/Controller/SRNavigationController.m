//
//  SRNavigationController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRNavigationController.h"

@implementation SRNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

+ (void)initialize {
    
    // 设置导航条的主题
    UINavigationBar *navBar =[UINavigationBar appearance];
    
    // 导航条背景图片注意:
    // 1.iOS7.0以后背景图片的高度一定要64点.
    // 2.背景图片的宽度无限制自动拉伸.
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    // 导航条返回按钮的颜色 apply to the navigation items and bar button items
    [navBar setTintColor:[UIColor whiteColor]];
    
    // 导航条标题的字体和颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:titleAttr];
    
    // 设置UIBarButtonItem的主题
    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearance];
    if (([[UIDevice currentDevice].systemVersion doubleValue]) >= 7.0) {
        [barBtnItem setTintColor:[UIColor whiteColor]];
        NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
        titleAttr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        [barBtnItem setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
        [barBtnItem setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    } else {
        UIImage *normalImage = [UIImage imageNamed:@"NavButton"];
        [barBtnItem setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *highImage = [UIImage imageNamed:@"NavButtonPressed"];
        [barBtnItem setBackgroundImage:highImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        UIImage *normalBackImage = [UIImage imageNamed:@"NavBackButton"];
        [barBtnItem setBackgroundImage:normalBackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        UIImage *highBackImage = [UIImage imageNamed:@"NavBackButtonPressed"];
        [barBtnItem setBackgroundImage:highBackImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //NSLog(@"%s", __func__);
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    //NSLog(@"%s",__func__);
    return [super popViewControllerAnimated:animated];
}

@end
