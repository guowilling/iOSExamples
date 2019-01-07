//
//  SRHelpTableViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRHelpTableViewController.h"
#import "SRHelp.h"
#import "SRHelpHtmlViewController.h"

@interface SRHelpTableViewController ()

@property (nonatomic, strong) NSArray *helps;

@end

@implementation SRHelpTableViewController

- (NSArray *)helps {
    
    if (_helps == nil) {
        _helps = [SRHelp helps];
    }
    return _helps;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (SRHelp *help in self.helps) {
        SRSettingItem *item = [[SRSettingItem alloc] initWithIcon:nil title:help.title];
        [arrayM addObject:item];
    }
    SRSettingGroup *group = [[SRSettingGroup alloc] init];
    group.settingItems = arrayM;
    [self.datas addObject:group];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SRHelpHtmlViewController *hhVC = [[SRHelpHtmlViewController alloc] init];
    hhVC.help = self.helps[indexPath.row];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hhVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
