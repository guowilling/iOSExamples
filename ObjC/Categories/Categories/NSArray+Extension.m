//
//  NSArray+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

+ (BOOL)isAvailable:(NSArray *)aArray {
    if (aArray && ![aArray isKindOfClass:NSNull.class] && aArray.count > 0) {
        return YES;
    }
    return NO;
}

+ (instancetype)removeDuplicateElements:(NSArray *)sourceArray {
    NSMutableArray *newArray = [NSMutableArray new];
    for (int i = 0; i < sourceArray.count; i++) {
        if (![newArray containsObject:sourceArray[i]]) {
            [newArray addObject:sourceArray[i]];
        }
    }
    return newArray;
}

/** 中文字符输出 */
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *description = [NSMutableString string];
    [description appendString:@"[\n"]; // 开头的 '['
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [description appendFormat:@"\t%@,\n", obj];
    }];
    [description appendString:@"]"]; // 结尾的 ']'
    
    NSRange range = [description rangeOfString:@"," options:NSBackwardsSearch]; // 查出最后一个','的范围
    if (range.length != 0) {
        [description deleteCharactersInRange:range]; // 删掉最后一个','
    }
    return description;
}

@end
