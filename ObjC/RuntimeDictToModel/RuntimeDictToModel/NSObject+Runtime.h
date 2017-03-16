//
//  NSObject+Runtime.h
//  RuntimeDictToModel
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (instancetype)sr_objWithDict:(NSDictionary *)dict;

/** 属性列表 */
+ (NSArray *)sr_objProperties;

@end
