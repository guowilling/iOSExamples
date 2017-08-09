//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRModelTool.h"
#import "SRModelProtocol.h"
#import <objc/runtime.h>

@implementation SRModelTool

+ (NSString *)tableName:(Class)cls {
    
    return NSStringFromClass(cls);
}

+ (NSString *)tableNameTmp:(Class)cls {
    
    return [NSStringFromClass(cls) stringByAppendingString:@"_tmp"];
}

+ (NSDictionary *)classIvarsNameOCTypeDic:(Class)cls {
    
    unsigned int outCount = 0;
    Ivar *varList = class_copyIvarList(cls, &outCount);
    
    NSMutableDictionary *nameTypeDic = [NSMutableDictionary dictionary];
    NSArray *ignoreNames = nil;
    if ([cls respondsToSelector:@selector(ignoreIvarsNames)]) {
        ignoreNames = [cls ignoreIvarsNames];
    }
    
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = varList[i];
        NSString *ivarName = [NSString stringWithUTF8String: ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }

        if([ignoreNames containsObject:ivarName]) {
            continue;
        }
        
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        [nameTypeDic setValue:type forKey:ivarName];
    }
    return nameTypeDic;
}

+ (NSDictionary *)classIvarsNameSqliteTypeDic:(Class)cls {
    
    NSMutableDictionary *nameOCTypeDic = [self classIvarsNameOCTypeDic:cls].mutableCopy;
    NSDictionary *typeDic = [self ocTypeToSqliteTypeDic];
    [nameOCTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        nameOCTypeDic[key] = typeDic[obj];
    }];
    return nameOCTypeDic;
}

+ (NSString *)fieldsNameAndTypeString:(Class)cls {
    
    NSDictionary *nameTypeDic = [self classIvarsNameSqliteTypeDic:cls];
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
   
    }];
    return [result componentsJoinedByString:@","];
}

+ (NSArray *)sortedIvarsName:(Class)cls {
    
    NSDictionary *dic = [self classIvarsNameOCTypeDic:cls];
    NSArray *keys = dic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return keys;
}

+ (NSDictionary *)ocTypeToSqliteTypeDic {
    
    return @{@"d": @"real",     // double
             @"f": @"real",     // float
             @"i": @"integer",  // int
             @"q": @"integer",  // long
             @"Q": @"integer",  // long long
             @"B": @"integer",  // bool
             
             @"NSString": @"text",
             
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             
             @"NSData": @"blob"};
}

@end
