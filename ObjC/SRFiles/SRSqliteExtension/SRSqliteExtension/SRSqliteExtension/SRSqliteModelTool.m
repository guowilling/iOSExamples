//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRSqliteModelTool.h"
#import "SRModelTool.h"
#import "SRSqliteTool.h"
#import "SRSqliteTableTool.h"

@implementation SRSqliteModelTool

+ (BOOL)createTable:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"Must implementation primaryKey!");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@))", tableName, [SRModelTool fieldsNameAndTypeString:cls], primaryKey];
    return [SRSqliteTool executeSQL:createTableSql uid:uid];
}

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid {
    
    NSArray *modelNames = [SRModelTool sortedIvarsName:cls];
    NSArray *tableNames = [SRSqliteTableTool sortedTableFieldsName:cls uid:uid];
    return ![modelNames isEqualToArray:tableNames];
}

+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        return NO;
    }
    NSString *tmpTableName = [SRModelTool tableNameTmp:cls];
    NSString *tableName = [SRModelTool tableName:cls];
    
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *dropTmpTableSql = [NSString stringWithFormat:@"drop table if exists %@;", tmpTableName];
    [execSqls addObject:dropTmpTableSql];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [SRModelTool fieldsNameAndTypeString:cls], primaryKey];
    [execSqls addObject:createTableSql];
    
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    
    NSArray *oldNames = [SRSqliteTableTool sortedTableFieldsName:cls uid:uid];
    NSArray *newNames = [SRModelTool sortedIvarsName:cls];
    
    NSDictionary *newNameToOldNameDic = @{};
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        if ([newNameToOldNameDic[columnName] length] != 0) {
            oldName = newNameToOldNameDic[columnName];
        }
        
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@);", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@;", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@;", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    return [SRSqliteTool executeSQLs:execSqls uid:uid];
}

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid {
    
    Class cls = [model class];
    if (![SRSqliteTableTool isTableExists:cls uid:uid]) {
        [self createTable:cls uid:uid];
    }
    
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        BOOL updateSuccess = [self updateTable:cls uid:uid];
        if (!updateSuccess) {
            return NO;
        }
    }
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        return NO;
    }
    
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [SRSqliteTool querySQL:checkSql uid:uid];
    
    NSArray *columnNames = [SRModelTool classIvarsNameOCTypeDic:cls].allKeys;
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [values addObject:value];
    }
    
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'", name, value];
        [setValueArray addObject:setStr];
    }
    
    NSString *execSql = @"";
    if (result.count > 0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
    } else {
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    return [SRSqliteTool executeSQL:execSql uid:uid];
}

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    
    Class cls = [model class];
    NSString *tableName = [SRModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    return [SRSqliteTool executeSQL:deleteSql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereStr.length > 0) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@", whereStr];
    }
    return [SRSqliteTool executeSQL:deleteSql uid:uid];
}

+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, name, self.columnNameToValueRelationTypeDic[@(relation)], value];
    return [SRSqliteTool executeSQL:deleteSql uid:uid];
}

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    NSArray<NSDictionary *> *results = [SRSqliteTool querySQL:sql uid:uid];
    return [self parseResults:results withClass:cls];;
}

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [SRModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@' ", tableName, name, self.columnNameToValueRelationTypeDic[@(relation)], value];
    NSArray <NSDictionary *>*results = [SRSqliteTool querySQL:sql uid:uid];
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls sql:(NSString *)sql uid:(NSString *)uid {
    
    NSArray <NSDictionary *>*results = [SRSqliteTool querySQL:sql uid:uid];
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {
    
    NSMutableArray *models = [NSMutableArray array];
    NSDictionary *nameTypeDic = [SRModelTool classIvarsNameOCTypeDic:cls];
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *type = nameTypeDic[key];
            id resultValue = obj;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            } else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            [model setValue:resultValue forKeyPath:key];
        }];
    }
    return models;
}

+ (NSDictionary *)columnNameToValueRelationTypeDic {
    
    return @{@(ColumnNameToValueRelationTypeMore): @">",
             @(ColumnNameToValueRelationTypeLess): @"<",
             @(ColumnNameToValueRelationTypeEqual): @"=",
             @(ColumnNameToValueRelationTypeMoreEqual): @">=",
             @(ColumnNameToValueRelationTypeLessEqual): @"<="};
}

@end
