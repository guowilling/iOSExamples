//
//  MyTabBarController.m
//  XianyuTabBar
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "MyTabBarController.h"
#import "MyTabBar.h"
#import "MyNavigationController.h"
#import "HomeViewController.h"
#import "FishViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "PostViewController.h"

@interface MyTabBarController () <MyTabBarDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupAllChildVC];
    
    MyTabBar *tabbar = [[MyTabBar alloc] init];
    tabbar.myDelegate = self;
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

- (void)setupAllChildVC {
    
    [self setUpOneChildVcWithVc:[[HomeViewController alloc] init]
                          Image:@"home_normal"
                  selectedImage:@"home_highlight"
                          title:@"首页"];
    
    [self setUpOneChildVcWithVc:[[FishViewController alloc] init]
                          Image:@"fish_normal"
                  selectedImage:@"fish_highlight"
                          title:@"鱼塘"];
    
    [self setUpOneChildVcWithVc:[[MessageViewController alloc] init]
                          Image:@"message_normal"
                  selectedImage:@"message_highlight"
                          title:@"消息"];
    
    [self setUpOneChildVcWithVc:[[MineViewController alloc] init]
                          Image:@"account_normal"
                  selectedImage:@"account_highlight"
                          title:@"我的"];
}

- (void)setUpOneChildVcWithVc:(UIViewController *)VC Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    
    MyNavigationController *navC = [[MyNavigationController alloc] initWithRootViewController:VC];
    VC.view.backgroundColor = [self randomColor];
    VC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.title = title;
    VC.navigationItem.title = title;
    [self addChildViewController:navC];
}

- (UIColor *)randomColor {
    
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

#pragma mark - MyTabBarDelegate

- (void)tabBarDidClickPlusBtn:(MyTabBar *)tabBar {
    
    PostViewController *VC = [[PostViewController alloc] init];
    VC.view.backgroundColor = [self randomColor];
    MyNavigationController *navC = [[MyNavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:navC animated:YES completion:nil];
}

@end
