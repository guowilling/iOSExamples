//
//  SRShopTool.m
//  FMDB基础
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRShopTool.h"
#import "FMDB.h"
#import "SRShop.h"

// 查询操作
//[db executeQuery:(NSString *), ...];

// 其它操作
//[db executeUpdate:(NSString *), ...];

@implementation SRShopTool

static FMDatabase *database;

+ (void)initialize {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops.sqlite"];
    database = [FMDatabase databaseWithPath:filePath];
    [database open];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, price real);"];
}

+ (void)addShop:(SRShop *)shop {
    BOOL flag;
    //flag = [database executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %f);", shop.name, shop.price]; // FMDB 字符串不用加上 ''
    flag = [database executeUpdate:@"insert into t_shop(name,price) values (?,?);", shop.name, @(shop.price)]; // '?' 是数据库里面的占位符
    if (!flag) {
        NSLog(@"操作数据库失败");
    }
}

+ (NSArray *)shops {
    FMResultSet *set = [database executeQuery:@"SELECT * FROM t_shop;"];
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        SRShop *shop = [[SRShop alloc] init];
        shop.name = [set stringForColumn:@"name"];
        shop.price = [set doubleForColumn:@"price"];
        [shops addObject:shop];
    }
    return shops;
}

+ (void)deleteShop:(float)price {
    [database executeUpdate:@"DELETE FROM t_shop WHERE price < ?;", @(price)];
}

@end
