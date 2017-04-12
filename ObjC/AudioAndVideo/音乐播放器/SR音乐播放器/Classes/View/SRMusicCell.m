//
//  SRMusicCell.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRMusicCell.h"
#import "SRMusic.h"
#import "Colours.h"
#import "UIImage+BoxBlur.h"
#import "UIImage+Extension.h"

@interface SRMusicCell ()

@property (nonatomic, weak) UIView *line;

@end

@implementation SRMusicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * const reuseIdentifier = @"musicCell";
    SRMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[SRMusicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)setMusic:(SRMusic *)music
{
    _music = music;
    
    self.imageView.image = [UIImage roundImageWithName:music.singerIcon borderWidth:3 borderColor:[UIColor skyBlueColor]];
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(86, self.frame.size.height - self.line.frame.size.height, [UIScreen mainScreen].bounds.size.width, 1);
}

@end
