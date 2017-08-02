//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRSqliteTool.h"
#import "sqlite3.h"

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

//#define kCachePath @"/Users/guoweilin/Desktop"

@implementation SRSqliteTool

sqlite3 *ppDb = nil;

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid {
    
    if (![self openDB:uid]) {
        NSLog(@"open DB error!");
        return NO;
    }
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    [self closeDB];
    return result;
}

+ (NSMutableArray <NSMutableDictionary *>*)querySql:(NSString *)sql uid:(NSString *)uid {
    
    [self openDB:uid];

    sqlite3_stmt *ppStmt = nil;
    if (sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        NSLog(@"prepare SQL error!");
        return nil;
    }
    
    NSMutableArray *rowDicArray = [NSMutableArray array];
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        int columnCount = sqlite3_column_count(ppStmt);
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        for (int i = 0; i < columnCount; i++) {
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            int type = sqlite3_column_type(ppStmt, i);
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                case SQLITE_NULL:
                    value = @"";
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String: (const char *)sqlite3_column_text(ppStmt, i)];
                    break;
            }
            [rowDic setValue:value forKey:columnName];
        }
    }
    
    sqlite3_finalize(ppStmt);
    
    [self closeDB];
    
    return rowDicArray;
}

+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid {
    
    if (![self openDB:uid]) {
        NSLog(@"open DB error!");
        return NO;
    }
    
    NSString *begin = @"begin transaction";
    sqlite3_exec(ppDb, begin.UTF8String, nil, nil, nil);
    
    for (NSString *sql in sqls) {
        BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
        if (result == NO) {
            NSString *rollBack = @"rollback transaction";
            sqlite3_exec(ppDb, rollBack.UTF8String, nil, nil, nil);
            [self closeDB];
            return NO;
        }
    }
    
    NSString *commit = @"commit transaction";
    sqlite3_exec(ppDb, commit.UTF8String, nil, nil, nil);
    [self closeDB];
    
    return YES;
}

#pragma mark - Private Methods

+ (BOOL)openDB:(NSString *)uid {
    
    NSString *dbName = @"common.sqlite";
    if (uid && uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite", uid];
    }
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];
    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}

+ (void)closeDB {
    
    sqlite3_close(ppDb);
}

+ (void)beginTransaction:(NSString *)uid {
    
    [self deal:@"begin transaction" uid:uid];
}

+ (void)commitTransaction:(NSString *)uid {
    
    [self deal:@"commit transaction" uid:uid];
}

+ (void)rollBackTransaction:(NSString *)uid {
    
    [self deal:@"rollback transaction" uid:uid];
}

@end
