//
//  SRLrcCell.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/28.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRLrcLine;

@interface SRLrcCell : UITableViewCell

@property (nonatomic, strong) SRLrcLine *lrcLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
