//
//  UIButton+Swizzling.m
//  PreventQuickTap
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIButton+Swizzling.h"
#import <objc/runtime.h>

@implementation UIButton (Swizzling)

- (NSTimeInterval)eventInterval {
    
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval {
    
    objc_setAssociatedObject(self, @selector(eventInterval), @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent {
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    
    objc_setAssociatedObject(self, @selector(ignoreEvent), [NSNumber numberWithBool:ignoreEvent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    
    Method original = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method new = class_getInstanceMethod(self, @selector(hook_sendAction:to:forEvent:));
    method_exchangeImplementations(original, new);
}

- (void)hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.ignoreEvent) {
        return;
    }
    
    [self hook_sendAction:action to:target forEvent:event];
    
    if (self.eventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(acceptEvent) withObject:nil afterDelay:self.eventInterval];
    }
}

- (void)acceptEvent {
    
    self.ignoreEvent = NO;
}

@end
