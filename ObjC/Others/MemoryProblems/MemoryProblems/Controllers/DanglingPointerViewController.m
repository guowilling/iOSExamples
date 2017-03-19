//
//  NameListViewController.m
//  MemoryProblems
//
//  Created by SR on 11/15/15.
//  Copyright © 2015 SR. All rights reserved.
//

#import "DanglingPointerViewController.h"
#import "TableViewDataSource.h"

static NSString * const kNameCellIdentifier = @"NameCell";

@interface DanglingPointerViewController ()

//@property (strong, nonatomic) TableViewDataSource *dataSource; // OK.

//@property (assign, nonatomic) TableViewDataSource *dataSource; // Not OK, and will not crash.

@property (weak, nonatomic) TableViewDataSource *dataSource; // Not OK, but will not crash.

@end

@implementation DanglingPointerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataSource = [[TableViewDataSource alloc] initWithItems:@[@"Sam", @"Mike", @"John", @"Paul", @"Jason"]
                                              cellIdentifier:kNameCellIdentifier
                                              tableViewStyle:UITableViewCellStyleDefault
                                          configureCellBlock:^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath) {
                                              cell.textLabel.text = item;
                                          }];
    // ARC 环境下这里会对 _dataSource 做了一次 release 操作.
    
    // weak 会在对象被释放后会自动把指针置空, assign 不会.
    self.tableView.dataSource = _dataSource; // -[ArrayDataSource retain]: message sent to deallocated instance 0x17424e070
}

@end
