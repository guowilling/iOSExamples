//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRSqliteTableTool.h"
#import "SRModelTool.h"
#import "SRSqliteTool.h"

@implementation SRSqliteTableTool

+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableArray *result = [SRSqliteTool querySql:queryCreateSqlStr uid:uid];
    return result.count > 0;
}

+ (NSArray *)sortedTableFieldsName:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    NSMutableDictionary *result = [SRSqliteTool querySql:queryCreateSqlStr uid:uid].firstObject;
    NSString *createTableSQLString = result[@"sql"];
    if (createTableSQLString.length == 0) {
        return nil;
    }
    createTableSQLString = [createTableSQLString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createTableSQLString = [createTableSQLString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSString *nameTypeString = [createTableSQLString componentsSeparatedByString:@"("][1];
    NSArray *nameTypeArray = [nameTypeString componentsSeparatedByString:@","];
    NSMutableArray *fieldsName = [NSMutableArray array];
    for (NSString *nameType in nameTypeArray) {
        if ([[nameType lowercaseString] containsString:@"primary"]) {
            continue;
        }
        NSString *nameTypeTemp = [nameType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSString *name = [nameTypeTemp componentsSeparatedByString:@" "].firstObject;
        [fieldsName addObject:name];
    }
    
    [fieldsName sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    return fieldsName;
}

@end
