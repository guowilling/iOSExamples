//
//  SRPushNoticeTableViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRPushNoticeTableViewController.h"
#import "SRSettingArrowItem.h"
#import "SRSettingGroup.h"
#import "SRSettingCell.h"
#import "SRAwardNumPushViewController.h"
#import "SRAwardAnimationVIewController.h"
#import "SRScoreLiveViewController.h"

@interface SRPushNoticeTableViewController ()

@end

@implementation SRPushNoticeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self add0SectionItems];
}

- (void)add0SectionItems {
    
    SRSettingArrowItem *item00 = [[SRSettingArrowItem alloc]initWithIcon:nil title:@"开奖号码推送" destClass:[SRAwardNumPushViewController class]];
    SRSettingArrowItem *item01 = [[SRSettingArrowItem alloc]initWithIcon:nil title:@"中奖动画" destClass:[SRAwardAnimationVIewController class]];
    SRSettingArrowItem *item02 = [[SRSettingArrowItem alloc]initWithIcon:nil title:@"比分直播" destClass:[SRScoreLiveViewController class]];
    SRSettingGroup *group0 = [[SRSettingGroup alloc] init];
    group0.settingItems = @[item00, item01, item02];
    [self.datas addObject:group0];
}

@end
