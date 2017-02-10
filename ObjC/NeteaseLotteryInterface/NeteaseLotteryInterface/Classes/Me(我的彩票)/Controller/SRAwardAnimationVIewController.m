//
//  SRAwardAnimationVIewController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRAwardAnimationVIewController.h"

@implementation SRAwardAnimationVIewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self add0SectionItems];
}

- (void)add0SectionItems {
    
    SRSettingSwitchItem *item01 = [[SRSettingSwitchItem alloc] initWithIcon:nil title:@"中奖动画"];
    SRSettingGroup *group0 = [[SRSettingGroup alloc] init];
    group0.settingItems = @[item01];
    group0.footerTitle = @"想中奖呵呵呵";
    [self.datas addObject:group0];
}

@end
