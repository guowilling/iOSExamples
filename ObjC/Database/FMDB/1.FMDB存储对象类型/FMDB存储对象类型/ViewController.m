//
//  ViewController.m
//  FMDB存储对象类型
//
//  Created by 郭伟林 on 16/3/23.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRShop.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDB];
    
    [self addShops];
}

- (void)setupDB {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"shops.sqlite"];
    self.database = [FMDatabase databaseWithPath:filePath];
    [self.database open];
    [self.database executeUpdate:@"CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, shop blob NOT NULL);"];
}

- (void)addShops {
    for (int i = 0; i < 100; i++) {
        SRShop *shop = [[SRShop alloc] init];
        shop.name = [NSString stringWithFormat:@"商品%d", i];
        shop.price = arc4random() % 10000;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shop];
        [self.database executeUpdateWithFormat:@"INSERT INTO t_shop(shop) VALUES (%@);", data];
    }
    
    // 归档
//    NSMutableArray *shops = [NSMutableArray array];
//    for (int i = 0; i < 1000; i++) {
//        HMShop *shop = [[HMShop alloc] init];
//        shop.name = [NSString stringWithFormat:@"商品%d", i];
//        shop.price = arc4random() % 10000;
//        [shops addObject:shop];
//    }
//    [NSKeyedArchiver archiveRootObject:shops toFile:@"/Users/apple/Desktop/shops.data"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self readShops];
}

- (void)readShops {
    FMResultSet *set = [self.database executeQuery:@"SELECT * FROM t_shop LIMIT 10;"];
    while (set.next) {
        NSData *data = [set objectForColumnName:@"shop"];
        SRShop *shop = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"%@", shop);
    }
    
    // 解档
//    NSMutableArray *shops = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/guoweilin/Desktop/shops.data"];
//    NSLog(@"%@", [shops subarrayWithRange:NSMakeRange(20, 10)]);
}

@end
