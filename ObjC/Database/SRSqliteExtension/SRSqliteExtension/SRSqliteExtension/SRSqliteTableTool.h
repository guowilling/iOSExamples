//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSqliteTableTool : NSObject

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid;

+ (NSArray *)sortedTableFieldsName:(Class)cls uid:(NSString *)uid;

@end
