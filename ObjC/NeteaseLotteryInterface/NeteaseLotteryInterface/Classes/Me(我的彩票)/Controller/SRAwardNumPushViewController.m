//
//  SRAwardNumPushViewController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRAwardNumPushViewController.h"
#import "SRSettingSwitchItem.h"
#import "SRSettingGroup.h"

@implementation SRAwardNumPushViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self add0SectionItems];
}

- (void)add0SectionItems {
    
    SRSettingSwitchItem *item01 = [[SRSettingSwitchItem alloc] initWithIcon:nil title:@"双色球"];
    SRSettingSwitchItem *item02 = [[SRSettingSwitchItem alloc] initWithIcon:nil title:@"大乐透"];
    SRSettingGroup *group0 = [[SRSettingGroup alloc] init];
    group0.settingItems = @[item01, item02];
    group0.headerTitle = @"双色球大乐透呵呵呵";
    [self.datas addObject:group0];
}

@end
