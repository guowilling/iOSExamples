//
//  NSArray+Swizzling.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/9.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") methodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                                                        swizzledSelector:@selector(hook_objectAtIndex:)];
    });
}

- (id)hook_objectAtIndex:(NSUInteger)index {
    
    if (self.count == 0) {
        NSLog(@"%s the array is empty.", __FUNCTION__);
        return nil;
    }
    if (index >= self.count) {
        NSLog(@"%s %zd index is out of bounds.", __FUNCTION__, index);
        return nil;
    }
    return [self hook_objectAtIndex:index];
}

@end
