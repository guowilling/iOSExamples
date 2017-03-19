//
//  UIScrollView+BossRefresh.h
//  BossHeaderRefreshDemo
//
//  Created by 郭伟林 on 17/2/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BossHeaderRefresh;

@interface UIScrollView (BossRefresh)

@property (nonatomic, weak, readonly) BossHeaderRefresh *headerRefresh;

- (void)addHeaderRefreshWithHandler:(void (^)())handler;

@end
