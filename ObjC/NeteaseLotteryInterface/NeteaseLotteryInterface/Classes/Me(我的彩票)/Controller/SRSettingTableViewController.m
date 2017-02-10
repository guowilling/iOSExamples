//
//  SRSettingTableViewController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRSettingTableViewController.h"
#import "SRPushNoticeTableViewController.h"
#import "SRHelpTableViewController.h"
#import "SRShareTableViewController.h"
#import "SRProductViewController.h"
#import "SRAboutTableViewController.h"
#import "MBProgressHUD+Extend.h"

@implementation SRSettingTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"%s", __func__);
    
    [self add0SectionItems];
    
    [self add1SectionItems];
}

- (void)add0SectionItems {
    
    SRSettingArrowItem * pushNotice = [[SRSettingArrowItem alloc] initWithIcon:@"MorePush" title:@"推送和提醒" destClass:[SRPushNoticeTableViewController class]];
    SRSettingSwitchItem *shake = [[SRSettingSwitchItem alloc] initWithIcon:@"handShake" title:@"摇一摇机选"];
    SRSettingSwitchItem *sound = [[SRSettingSwitchItem alloc] initWithIcon:@"sound_Effect" title:@"声音效果"];
    SRSettingGroup *group0 = [[SRSettingGroup alloc] init];
    group0.settingItems = @[pushNotice, shake, sound];
    [self.datas addObject:group0];
}

- (void)add1SectionItems {
    
    SRSettingArrowItem *update = [[SRSettingArrowItem alloc] initWithIcon:@"MoreUpdate" title:@"检查新版本"];
    update.option = ^{
        [MBProgressHUD showMessage:@"正在检查"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"亲~没有新版本哦"];
        });
    };
    SRSettingArrowItem *help = [[SRSettingArrowItem alloc] initWithIcon:@"MoreHelp" title:@"帮助" destClass:[SRHelpTableViewController class]];
    SRSettingArrowItem *share = [[SRSettingArrowItem alloc] initWithIcon:@"MoreShare" title:@"分享" destClass:[SRShareTableViewController class]];
    SRSettingArrowItem *message = [[SRSettingArrowItem alloc] initWithIcon:@"MoreMessage" title:@"查看消息"];
    SRSettingArrowItem *product = [[SRSettingArrowItem alloc] initWithIcon:@"MoreNetease" title:@"产品推荐" destClass:[SRProductViewController class]];
    SRSettingArrowItem *about = [[SRSettingArrowItem alloc] initWithIcon:@"MoreAbout" title:@"关于" destClass:[SRAboutTableViewController class]];
    SRSettingGroup *group1 = [[SRSettingGroup alloc] init];
    group1.settingItems = @[update, help, share, message, product, about];
    [self.datas addObject:group1];
}

@end
