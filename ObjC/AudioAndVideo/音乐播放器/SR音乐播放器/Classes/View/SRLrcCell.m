//
//  SRLrcCell.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/28.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRLrcCell.h"
#import "SRLrcLine.h"

@interface SRLrcCell ()

@end

@implementation SRLrcCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseIdentifier = @"lrcCell";
    SRLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[SRLrcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

- (void)setLrcLine:(SRLrcLine *)lrcLine
{
    _lrcLine = lrcLine;
    
    self.textLabel.text = lrcLine.word;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
