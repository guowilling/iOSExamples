//
//  SRTabBar.h
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/21.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRTabBarButton, SRTabBar;

@protocol SRTabBarDelegate <NSObject>

- (void)tabBarSelectedBtn:(SRTabBar *)tabBar btn:(SRTabBarButton *)btn;

@end

#pragma mark - SRTabBar

@interface SRTabBar : UIView

@property (nonatomic, weak) id<SRTabBarDelegate> delegate;

- (void)addTabBarButtonWithNormalImageName:(NSString *)norName andDisabledImageName:(NSString *)disName;

@end

#pragma mark - SRTabBarButton

@interface SRTabBarButton : UIButton

@end
