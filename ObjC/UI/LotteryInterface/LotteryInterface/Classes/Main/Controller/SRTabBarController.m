//
//  MainTabBarController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/21.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRTabBarController.h"
#import "SRTabBar.h"

@interface SRTabBarController () <SRTabBarDelegate>

@property (nonatomic, strong) SRTabBarButton *selectedBtn;

@end

@implementation SRTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    SRTabBar *srTabBar = [[SRTabBar alloc] init];
    //srTabBar.frame = self.tabBar.frame; // 注意不是frame
    srTabBar.frame = self.tabBar.bounds;
    
    //[self.view addSubview:srTabBar]; // 注意不是self.view, 不然push控制器时不能隐藏tabBar!
    [self.tabBar addSubview:srTabBar];
    
    srTabBar.delegate = self;
    
    // 创建5个按钮添加到自定义TabBar
//    for (int i =0; i <5; i++) {
//        SRTabBarButton *btn = [[SRTabBarButton alloc] init];
//        NSString *nomalImageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
//        NSString *disabledImageName = [NSString stringWithFormat:@"TabBar%dSel", i +1];
//        [btn setBackgroundImage:[UIImage imageNamed:nomalImageName] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
//        CGFloat w = tabBar.frame.size.width / 5;
//        CGFloat h = tabBar.frame.size.height;
//        CGFloat x = i * w;
//        CGFloat y = 0;
//        btn.frame = CGRectMake(x, y, w, h);
//        btn.tag = i;
//        btn.adjustsImageWhenHighlighted = NO;
//        [btn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [tabBar addSubview:btn];
//        if (0 == i) {
//            [self tabBarBtnClick:btn];
//        }
//    }
    for (int i =0; i < self.viewControllers.count; i++) {
        NSString *nomalImageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
        NSString *disabledImageName = [NSString stringWithFormat:@"TabBar%dSel", i + 1];
        [srTabBar addTabBarButtonWithNormalImageName:nomalImageName andDisabledImageName:disabledImageName];
    }
}

//- (void)tabBarBtnClick:(SRTabBarButton *)btn
//{
//    self.selectedBtn.enabled = YES;
//    self.selectedBtn = btn;
//    self.selectedBtn.enabled = NO;
//    self.selectedIndex = btn.tag;
//}

- (void)tabBarSelectedBtn:(SRTabBar *)tabBar btn:(SRTabBarButton *)btn {

    self.selectedIndex = btn.tag;
}

@end
