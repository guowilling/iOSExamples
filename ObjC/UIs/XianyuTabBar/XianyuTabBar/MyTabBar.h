//
//  MyTabBar.h
//  XianyuTabBar
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBar;

@protocol MyTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickPlusBtn:(MyTabBar *)tabBar;

@end

@interface MyTabBar : UITabBar

@property (nonatomic, weak) id<MyTabBarDelegate> myDelegate;

@end
