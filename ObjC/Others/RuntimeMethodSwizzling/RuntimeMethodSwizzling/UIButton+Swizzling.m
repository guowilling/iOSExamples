//
//  UIButton+Swizzling.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/9.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIButton+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

static const void *AcceptEventTimeIntervalKey = @"AcceptEventTimeIntervalKey";
static const void *IgnoreEventKey = &IgnoreEventKey;

@interface UIButton ()

@property (nonatomic, assign) BOOL ignoreEvent;

@end

@implementation UIButton (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(hook_SendAction:to:forEvent:)];
    });
}

- (void)hook_SendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.ignoreEvent) {
        return;
    }
    
    [self hook_SendAction:action to:target forEvent:event];
    
    if (self.acceptEventTimeInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(resetIgnoreEvent) withObject:nil afterDelay:self.acceptEventTimeInterval];
    }
}

- (void)resetIgnoreEvent {
    
    self.ignoreEvent = NO;
}

#pragma mark -

- (NSTimeInterval)acceptEventTimeInterval {
    
    return [objc_getAssociatedObject(self, AcceptEventTimeIntervalKey) doubleValue];
}

- (void)setAcceptEventTimeInterval:(NSTimeInterval)acceptEventTimeInterval {
    
    objc_setAssociatedObject(self, AcceptEventTimeIntervalKey, @(acceptEventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    
    objc_setAssociatedObject(self, IgnoreEventKey, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent {
    
    return [objc_getAssociatedObject(self, IgnoreEventKey) boolValue];
}

@end
