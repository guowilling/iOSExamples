//
//  ViewController.m
//  SQL练习
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"
#import "ContactTool.h"

@interface ViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation ViewController

- (NSMutableArray *)contacts {
    
    if (!_contacts) {
        _contacts = [[ContactTool contacts] mutableCopy];
        if (!_contacts) {
            _contacts = [NSMutableArray array];
        }
    }
    return _contacts;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (IBAction)insert:(id)sender {
    
    NSArray *nameArray = @[@"小明", @"小花", @"小红", @"小强"];
    NSString *name = [NSString stringWithFormat:@"%@%d", nameArray[arc4random_uniform(4)], arc4random_uniform(200)];
    NSString *phone = [NSString stringWithFormat:@"%d", arc4random_uniform(10000) + 10000];
    Contact *contact = [Contact contactWithName:name phone:phone];
    [self.contacts addObject:contact];
    [ContactTool saveWithContact:contact];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contacts.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // 模糊查询名字或者电话是否包含搜索关键字
    // stringWithFormat 中 '%' 是特殊字符 '%%' 才是 '%'
    NSString *sql = [NSString stringWithFormat:@"select * from t_contact where name like '%%%@%%' or phone like '%%%@%%';", searchText, searchText];
    // select * from t_contact where name like '%searchText%' or phone like '%searchText%'
    _contacts = [[ContactTool contactWithSql:sql] mutableCopy];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"%s", __func__);
    // 发送网络请求
    // ...
    // 刷新表格
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    Contact *contact  = self.contacts[indexPath.row];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phone;
    return cell;
}

@end
