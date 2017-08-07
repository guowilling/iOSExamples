//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSqliteTool : NSObject

+ (BOOL)executeSQL:(NSString *)sql uid:(NSString *)uid;

+ (BOOL)executeSQLs:(NSArray<NSString *> *)sqls uid:(NSString *)uid;

+ (NSMutableArray<NSMutableDictionary *> *)querySQL:(NSString *)sql uid:(NSString *)uid;

@end
