//
//  ViewController.m
//  SQL基础
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRShop.h"
#import <sqlite3.h>

@interface ViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) sqlite3 *sqliteDB;

@property (nonatomic, strong) NSMutableArray *shops;

@end

@implementation ViewController

- (NSMutableArray *)shops {
    
    if (!_shops) {
        self.shops = [[NSMutableArray alloc] init];
    }
    return _shops;
}

- (void)dealloc {
    
    sqlite3_close(self.sqliteDB);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //NSLog(@"%@", NSHomeDirectory());
    
    [self fakeData];

    [self setupSearchBar];
    
    [self connectDB];
    
    [self queryDB];
}

- (void)fakeData {
    
//    NSMutableString *sqlString = [NSMutableString string];
//    for (int i = 0; i < 10; i++) {
//        NSString *name = [NSString stringWithFormat:@"iPhone%d", i];
//        double price = arc4random() % 10000 + 100;
//        [sqlString appendFormat:@"insert into t_shop(name, price) values ('%@', %f);\n", name, price];
//    }
//    NSError *error;
//    if (![sqlString writeToFile:@"/Users/guoweilin/Desktop/shops.sqlite" atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
//        NSLog(@"error: %@", error);
//    }
    
//    NSMutableString *sqlStringM = [NSMutableString string];
//    for (int i = 0 ; i < 100; i++) {
//        NSString *sql = [NSString stringWithFormat:@"insert into t_student (name,age) values ('%@',%d);\n", [NSString stringWithFormat:@"aa%d", arc4random_uniform(100)], arc4random_uniform(100)];
//        [sqlStringM appendString:sql];
//    }
//    NSLog(@"%@", sqlStringM);
}

- (void)setupSearchBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 320, 44);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

- (void)connectDB {
    
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shops.sqlite"];
    int status = sqlite3_open(filename.UTF8String, &_sqliteDB); // 如果数据库文件不存在, 系统会自动创建文件自动初始化数据库.
    if (status == SQLITE_OK) {
        NSLog(@"数据库连接成功");
        const char *sql = "CREATE TABLE IF NOT EXISTS t_shop (id integer PRIMARY KEY, name text NOT NULL, price real);";
        char *error = NULL;
        sqlite3_exec(self.sqliteDB, sql, NULL, NULL, &error);
        if (error) {
            NSLog(@"创建表失败: %s", error);
        }
    } else {
        NSLog(@"数据库连接失败");
    }
}

- (void)queryDB {
    
    const char *sql = "SELECT name,price FROM t_shop;";
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare_v2(self.sqliteDB, sql, -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const char *name = (const char *)sqlite3_column_text(stmt, 0);
            const char *price = (const char *)sqlite3_column_text(stmt, 1);
            [self addShops:[NSString stringWithUTF8String:name] price:[NSString stringWithUTF8String:price]];
        }
    }
}

- (IBAction)insert {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_shop(name, price) VALUES ('%@', %f);", self.nameField.text, self.priceField.text.doubleValue];
    sqlite3_exec(self.sqliteDB, sql.UTF8String, NULL, NULL, NULL);
    [self addShops:self.nameField.text price:self.priceField.text];
    [self.tableView reloadData];
}

- (void)addShops:(NSString *)name price:(NSString *)price {
    
    SRShop *shop = [[SRShop alloc] init];
    shop.name = name;
    shop.price = price;
    [self.shops addObject:shop];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"shop";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor grayColor];
    }
    SRShop *shop = self.shops[indexPath.row];
    cell.textLabel.text = shop.name;
    cell.detailTextLabel.text = shop.price;
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.shops removeAllObjects];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT name,price FROM t_shop WHERE name LIKE '%%%@%%' OR price LIKE '%%%@%%';", searchText, searchText];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare_v2(self.sqliteDB, sql.UTF8String, -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const char *name = (const char *)sqlite3_column_text(stmt, 0);
            const char *price = (const char *)sqlite3_column_text(stmt, 1);
            [self addShops:[NSString stringWithUTF8String:name] price:[NSString stringWithUTF8String:price]];
        }
    }
    
    [self.tableView reloadData];
}

@end
