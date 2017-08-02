//
//  SRBaseTableViewController.h
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSettingGroup.h"
#import "SRSettingItem.h"
#import "SRSettingCell.h"
#import "SRSettingArrowItem.h"
#import "SRSettingSwitchItem.h"
#import "SRSettingLabelItem.h"

@interface SRBaseTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *datas;

@end
