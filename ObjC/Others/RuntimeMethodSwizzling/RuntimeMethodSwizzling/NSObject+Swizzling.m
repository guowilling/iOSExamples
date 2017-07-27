//
//  NSObject+Swizzling.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/9.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    //Method originalMethod = class_getInstanceMethod(self, originalSelector);
    //Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    //method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
