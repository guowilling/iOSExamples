//
//  BossHeaderRefresh.h
//  BossHeaderRefreshDemo
//
//  Created by 郭伟林 on 17/2/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+BossRefresh.h"

@interface BossHeaderRefresh : UIView

@property (nonatomic, copy) void (^handler)();

- (void)endRefreshing;

@end
