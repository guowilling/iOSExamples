//
//  SRMusicsViewController.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRMusicsViewController.h"
#import "SRMusic.h"
#import "SRMusicCell.h"
#import "SRMusicTool.h"
#import "SRPlayingViewController.h"

@interface SRMusicsViewController ()

@property (nonatomic, strong) SRPlayingViewController *playingVc;

@end

@implementation SRMusicsViewController

#pragma mark - 懒加载

- (SRPlayingViewController *)playingVc
{
    if (!_playingVc) {
        self.playingVc = [[SRPlayingViewController alloc] init];
    }
    return _playingVc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SRMusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRMusicCell *cell = [SRMusicCell cellWithTableView:tableView];
    SRMusic *music = [SRMusicTool musics][indexPath.row];
    cell.music = music;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SRMusic *music = [SRMusicTool musics][indexPath.row];
    [SRMusicTool setPlayingMusic:music];
    [self.playingVc show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

@end
