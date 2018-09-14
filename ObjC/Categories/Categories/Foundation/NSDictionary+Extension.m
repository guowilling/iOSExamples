//
//  NSDictionary+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

/** 中文字符输出 */
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *description = [NSMutableString string];
    [description appendString:@"{\n"]; // 开头的 '{'
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { // 遍历所有的键值对
        [description appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [description appendString:@"}"]; // 结尾的 '}'
    return description;
}

@end
