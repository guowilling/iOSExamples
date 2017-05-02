//
//  NSDictionary+Swizzling.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/9.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDictionary+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (Swizzling)

//+ (void)load {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [objc_getClass("__NSDictionaryI") methodSwizzlingWithOriginalSelector:@selector(objectForKey:)
//                                                             swizzledSelector:@selector(hook_objectForKey:)];
//    });
//}

- (id)hook_objectForKey:(id)aKey {
    
    if (!aKey) {
        NSLog(@"%s the key is nil.", __FUNCTION__);
        return nil;
    }
    if (![[self allKeys] containsObject:aKey]) {
        NSLog(@"%s the %@ key is not in the dictionary.", __FUNCTION__, aKey);
        return nil;
    }
    return [self hook_objectForKey:aKey];
}

@end
