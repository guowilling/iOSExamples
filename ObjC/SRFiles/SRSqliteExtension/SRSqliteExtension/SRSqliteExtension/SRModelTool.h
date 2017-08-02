//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRModelTool : NSObject

+ (NSString *)tableName:(Class)cls;

+ (NSString *)tableNameTmp:(Class)cls;

+ (NSDictionary *)classIvarsNameOCTypeDic:(Class)cls;

+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;

+ (NSString *)fieldsNameAndTypeString:(Class)cls;

+ (NSArray *)sortedIvarsName:(Class)cls;

@end
