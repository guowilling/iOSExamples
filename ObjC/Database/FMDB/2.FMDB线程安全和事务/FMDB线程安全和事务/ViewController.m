//
//  ViewController.m
//  FMDB线程安全和事务
//
//  Created by 郭伟林 on 16/3/23.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"user.sqlite"];
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    // 线程安全的 FMDatabase
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"create table if not exists t_user (id integer primary key autoincrement,name text,money integer)"];
        if (flag) {
            NSLog(@"success");
        } else {
            NSLog(@"failure");
        }
    }];
}

- (IBAction)add:(id)sender {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"insert into t_user (name,money) values (?,?)",@"a", @100];
        if (flag) {
            NSLog(@"添加 success");
        } else {
            NSLog(@"添加 failure");
        }
        [db executeUpdate:@"insert into t_user (name,money) values (?,?)",@"b", @100];
    }];
}

- (IBAction)delete:(id)sender {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:@"delete from t_user;"];
        if (flag) {
            NSLog(@"删除 success");
        }else{
            NSLog(@"删除 failure");
        }
    }];
}

- (IBAction)update:(id)sender {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction]; // 开启事务
        
        BOOL flag1 = [db executeUpdate:@"update t_user set money = ? where name = ?;", @1000, @"a"];
        if (flag1) {
            NSLog(@"修改1 success");
        } else {
            NSLog(@"修改1 failure");
            [db rollback]; // 回滚
        }
        
        BOOL flag2 = [db executeUpdate:@"update2 t_user set money = ? where name = ?;", @1000, @"b"]; // error
        if (flag2) {
            NSLog(@"修改2 success");
        } else {
            NSLog(@"修改2 failure");
            [db rollback]; // 回滚
        }
        
        [db commit]; // 全部操作完成后才提交
    }];
}

- (IBAction)select:(id)sender {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select * from t_user"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            int money = [result intForColumn:@"money"];
            NSLog(@"name: %@; money: %d",name,money);
        }
    }];
}

@end
