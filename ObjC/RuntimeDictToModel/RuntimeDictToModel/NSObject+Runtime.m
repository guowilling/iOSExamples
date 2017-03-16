//
//  NSObject+Runtime.m
//  RuntimeDictToModel
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

+ (instancetype)sr_objWithDict:(NSDictionary *)dict {
    
    id object = [[self alloc] init];
    NSArray *roperties = [self sr_objProperties];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([roperties containsObject:key]) {
            [object setValue:obj forKey:key];
        }
    }];
    return object;
}

const char * kObjPropertiesKey = "srObjProperties";

+ (NSArray *)sr_objProperties {
    
    NSArray *properties = objc_getAssociatedObject(self, kObjPropertiesKey);
    if (properties) {
        return properties;
    }
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [arrayM addObject:name];
    }
    
    free(propertyList);
    
    objc_setAssociatedObject(self, kObjPropertiesKey, arrayM.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return arrayM.copy;
    
    // Ivar     成员变量
    // Property 属性
    // Method   方法
    // Protocol 协议
}

@end
