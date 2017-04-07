//
//  ContactTool.m
//  SQL练习
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ContactTool.h"
#import "Contact.h"
#import <sqlite3.h>

@implementation ContactTool

static sqlite3 *sqlite3DB;

+ (void)initialize {
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    int status = (sqlite3_open(filePath.UTF8String, &sqlite3DB));
    if (status == SQLITE_OK) {
        NSLog(@"数据库连接成功");
    } else {
        NSLog(@"数据库连接失败");
    }
    
    NSString *sql = @"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);";
    char *error;
    sqlite3_exec(sqlite3DB, sql.UTF8String, NULL, NULL, &error);
    if (error) {
        NSLog(@"创建表失败");
    }
}

+ (BOOL)executeWithSql:(NSString *)sql {
    
    BOOL flag;
    char *error;
    sqlite3_exec(sqlite3DB, sql.UTF8String, NULL, NULL, &error);
    if (error) {
        NSLog(@"%s", error);
        flag = NO;
    } else {
        flag = YES;
    }
    return flag;
}

+ (void)saveWithContact:(Contact *)contact {
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_contact (name,phone) values ('%@','%@')", contact.name, contact.phone];
    BOOL flag = [self executeWithSql:sql];
    if (flag) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
    }
}

+ (NSArray *)contacts {
    
    return [self contactWithSql:@"select * from t_contact"];
}

+ (NSArray *)contactWithSql:(NSString *)sql {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    sqlite3_stmt *stmt = nil;
    int status = sqlite3_prepare_v2(sqlite3DB, sql.UTF8String, -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *phone = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            Contact *contact = [Contact contactWithName:name phone:phone];
            [arrayM addObject:contact];
        }
    }
    return arrayM;
}

@end
