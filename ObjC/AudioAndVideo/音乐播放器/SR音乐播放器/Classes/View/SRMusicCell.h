//
//  SRMusicCell.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRMusic;

@interface SRMusicCell : UITableViewCell

@property(nonatomic,strong) SRMusic *music;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
