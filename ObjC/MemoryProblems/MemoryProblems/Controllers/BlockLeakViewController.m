//
//  BlockLeakViewController.m
//  MemoryProblems
//
//  Created by SR on 11/15/15.
//  Copyright © 2015 SR. All rights reserved.
//

#import "BlockLeakViewController.h"
#import "TableViewDataSource.h"

static NSString * const kNameCellIdentifier = @"NameCell";

@interface BlockLeakViewController ()

@property (strong, nonatomic) TableViewDataSource *dataSource;

@end

@implementation BlockLeakViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //__weak typeof(self) weakSelf = self;
    _dataSource = [[TableViewDataSource alloc] initWithItems:@[@"Sam", @"Mike", @"John", @"Paul", @"Jason"]
                                              cellIdentifier:kNameCellIdentifier
                                              tableViewStyle:UITableViewCellStyleDefault
                                          configureCellBlock:^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath) {
                                              cell.textLabel.text = item;
                                              [self configureCell];
                                              //[weakSelf configureCell];
                                          }];
    
    self.tableView.dataSource = self.dataSource;
}

- (void)configureCell {
    
    NSLog(@"configureCell");
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end
