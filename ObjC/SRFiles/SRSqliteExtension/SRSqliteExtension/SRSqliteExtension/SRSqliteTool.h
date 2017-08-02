//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSqliteTool : NSObject

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;

+ (BOOL)dealSqls:(NSArray<NSString *> *)sqls uid:(NSString *)uid;

+ (NSMutableArray<NSMutableDictionary *> *)querySql:(NSString *)sql uid:(NSString *)uid;

@end
