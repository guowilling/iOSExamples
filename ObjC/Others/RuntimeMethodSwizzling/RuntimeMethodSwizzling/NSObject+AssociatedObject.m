//
//  NSObject+AssociatedObject.m
//  RuntimeMethodSwizzling
//
//  Created by 郭伟林 on 2018/8/17.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, @selector(associatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

@end
