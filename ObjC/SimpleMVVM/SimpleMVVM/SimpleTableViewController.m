//
//  SimpleTableViewController.m
//  SimpleMVVM
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "MJRefresh.h"
#import "SimpleModel.h"
#import "SimpleViewModel.h"
#import "SimpleTableViewCell.h"

@interface SimpleTableViewController ()

@property (nonatomic, strong) SimpleViewModel *simpleViewModel;

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"SimpleMVVM";
    
    self.simpleViewModel = [[SimpleViewModel alloc] init];
    
    [self setupHeaderRefresh];
    
    [self setupFooterRefresh];
}

- (void)setupHeaderRefresh {
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.simpleViewModel loadNewestDatasWithSuccess:^(BOOL success) {
            weakSelf.tableView.mj_footer.hidden = NO;
            if (success) {
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@", error);
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupFooterRefresh {
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.simpleViewModel loadMoreDatasWithSuccess:^(BOOL success) {
            if (success) {
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_footer endRefreshing];
            NSLog(@"%@", error);
        }];
    }];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.simpleViewModel.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"simpleTableViewCell";
    SimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.simpleModel = self.simpleViewModel.datas[indexPath.row];
    return cell;
}

@end
