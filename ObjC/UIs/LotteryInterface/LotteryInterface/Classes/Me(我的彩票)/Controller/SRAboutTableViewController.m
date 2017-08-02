//
//  SRAboutTableViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRAboutTableViewController.h"
#import "SRAboutHeaderView.h"

@interface SRAboutTableViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SRAboutTableViewController

- (void)viewDidLoad {
    
    [self addSectionItems];
    
    self.tableView.tableHeaderView = [SRAboutHeaderView headerView];
}

- (void)addSectionItems {
    
    SRSettingItem *item00 = [[SRSettingArrowItem alloc] initWithIcon:nil title:@"评分支持"];
    item00.option = ^{
        NSString *appID = @"1234567890";
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
    };
    
    SRSettingItem *item01 = [[SRSettingArrowItem alloc] initWithIcon:nil title:@"客服电话"];
    item01.subTitle = @"1234567890";
    item01.option = ^{ // 打电话
        // 电话挂断之后不会返回应用程序
        // NSURL *url = [NSURL URLWithString:@"tel://13261936021"];
        // [[UIApplication sharedApplication] openURL:url];
        
        // 私有API不能通过苹果审核
        // NSURL *url = [NSURL URLWithString:@"telprompt://13261936021"];
        // [[UIApplication sharedApplication] openURL:url];
     
        if (self.webView == nil) {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://18508235598"]]];
    };
    SRSettingGroup *group = [[SRSettingGroup alloc] init];
    group.settingItems = @[item00, item01];
    [self.datas addObject:group];
}

@end
