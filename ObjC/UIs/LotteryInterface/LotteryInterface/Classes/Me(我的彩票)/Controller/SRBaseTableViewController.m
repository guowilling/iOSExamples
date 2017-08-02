//
//  SRBaseTableViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#warning 基类实现TabbleView的数据源和代理方法, 子类只需要提供数据, 不用每个类都实现一样的方法.

#import "SRBaseTableViewController.h"

@implementation SRBaseTableViewController

#pragma mark - 懒加载

- (NSMutableArray *)datas {
    
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma mark - 初始化方法

- (id)init {
    
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style {
    
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"%s", __func__);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //NSLog(@"%s", __func__);
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"%s", __func__);
    SRSettingGroup *group = self.datas[section];
    return group.settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"%s", __func__);
    
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    SRSettingCell *cell = [SRSettingCell cellWithTableView:tableView];
    SRSettingGroup *group = self.datas[indexPath.section];
    SRSettingItem *settingItem = group.settingItems[indexPath.row];
    cell.settingItem = settingItem;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    SRSettingGroup *group = self.datas[section];
    return group.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return [self.datas[section] footerTitle];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    SRSettingGroup *group = self.datas[indexPath.section];
    SRSettingItem *item = group.settingItems[indexPath.row];
    if (item.option) {
        item.option();
    }
    if ([item isKindOfClass:[SRSettingArrowItem class]]) {
        SRSettingArrowItem *arrowItem = (SRSettingArrowItem *)item;
        UIViewController *vc = [[arrowItem.destClass alloc] init];
        if (vc) {
            vc.navigationItem.title = arrowItem.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 25;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 25;
//}

@end
