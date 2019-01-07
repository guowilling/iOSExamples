//
//  UIScrollView+BossRefresh.m
//  BossHeaderRefreshDemo
//
//  Created by 郭伟林 on 17/2/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIScrollView+BossRefresh.h"
#import "BossHeaderRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (BossRefresh)

#pragma mark - Swizzling

+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"hookDealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (void)hookDealloc {
    self.headerRefresh = nil;
    
    [self hookDealloc];
}

#pragma mark - 

- (void)addHeaderRefreshWithHandler:(void (^)())handler {
    BossHeaderRefresh *refreshHeader = [[BossHeaderRefresh alloc] init];
    refreshHeader.handler = handler;
    self.headerRefresh = refreshHeader;
    [self insertSubview:refreshHeader atIndex:0];
}

#pragma mark - Associate Object

- (void)setHeaderRefresh:(BossHeaderRefresh *)headerRefresh {
    objc_setAssociatedObject(self, @selector(headerRefresh), headerRefresh, OBJC_ASSOCIATION_ASSIGN);
}

- (BossHeaderRefresh *)headerRefresh {
    return objc_getAssociatedObject(self, @selector(headerRefresh));
}

@end
