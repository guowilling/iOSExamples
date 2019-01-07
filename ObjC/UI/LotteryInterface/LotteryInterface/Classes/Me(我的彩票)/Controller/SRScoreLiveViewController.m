//
//  SRScoreLiveViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRScoreLiveViewController.h"

@implementation SRScoreLiveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addSectionItems];
}

- (void)addSectionItems {
    
    SRSettingItem *item01 = [[SRSettingSwitchItem alloc]initWithIcon:nil title:@"关注比赛"];
    SRSettingGroup *group0 = [[SRSettingGroup alloc] init];
    group0.headerTitle = @"提醒我关注比赛呵呵呵";
    group0.settingItems = @[item01];
    [self.datas addObject:group0];
    
    SRSettingItem *item10 = [[SRSettingLabelItem alloc] initWithIcon:nil title:@"开始时间"];
    SRSettingGroup *group1 = [[SRSettingGroup alloc] init];
    group1.settingItems = @[item10];
    [self.datas addObject:group1];
    
    SRSettingItem *item20 = [[SRSettingLabelItem alloc] initWithIcon:nil title:@"结束时间"];
    SRSettingGroup *group2 = [[SRSettingGroup alloc] init];
    group2.settingItems = @[item20];
    [self.datas addObject:group2];
}

@end
