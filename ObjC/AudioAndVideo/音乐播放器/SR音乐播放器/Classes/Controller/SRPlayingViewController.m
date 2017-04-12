//
//  SRPlayingViewController.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRPlayingViewController.h"
#import "UIView+Extension.h"
#import "SRMusicTool.h"
#import "SRMusic.h"
#import "SRAudioTool.h"
#import "SRLrcView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SRPlayingViewController () <AVAudioPlayerDelegate>

/** 当前播放的音乐 */
@property (nonatomic, strong) SRMusic *playingMusic;

/** 音乐播放器 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 歌曲图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名称 */
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名称 */
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 时长 */
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

/** 辅助时间小方块 */
@property (weak, nonatomic) IBOutlet UIButton *currentTime;
/** 滑块按钮 */
@property (weak, nonatomic) IBOutlet UIButton *slider;
/** 播放进度条 */
@property (weak, nonatomic) IBOutlet UIView *progressView;
/** 播放或暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;

/** 上一首 */
- (IBAction)previous;
/** 下一首 */
- (IBAction)next;
/** 播放或暂停 */
- (IBAction)playOrPause;

/** 点击进度条手势 */
- (IBAction)onProgressBgTap:(UITapGestureRecognizer *)sender;
/** 拖拽滑块手势 */
- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender;

/** 进度条定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;
/** 歌词定时器 */
@property(nonatomic,strong) CADisplayLink *lrcTimer;

/** 歌词界面View */
@property (weak, nonatomic) IBOutlet SRLrcView *lrcView;

/** 退出界面 */
- (IBAction)exitBtnClick:(UIButton *)sender;
/** 歌词或图片界面切换 */
- (IBAction)lrcOrPic:(UIButton *)sender;

@end

@implementation SRPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentTime.layer.cornerRadius = 8;
}

- (void)show
{
    if(self.playingMusic != [SRMusicTool playingMusic]) {
        [self resetPlayingMusic]; // 不是正在播放的音乐, 重置数据.
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    self.view.hidden = NO;
    
    window.userInteractionEnabled = NO;
    self.view.y = window.bounds.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
    
    [self startPlayingMusic];
}

- (void)resetPlayingMusic
{
    [self removeProgressTimer];
    [self removeLrcTimer];
    
    self.durationLabel.text = nil;
    self.singerLabel.text = nil;
    self.songLabel.text = nil;
    self.iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    
    [SRAudioTool stopMusicWithFilename:self.playingMusic.filename];
    self.player = nil;
    self.playOrPauseButton.selected = NO;
}

- (void)startPlayingMusic
{
    if (self.playingMusic == [SRMusicTool playingMusic]) {
        [self addProgressTimer];
        [self addLrcTimer];
        return;
    }
    
    SRMusic *music = [SRMusicTool playingMusic];
    self.player = [SRAudioTool playMusicWithFilename:music.filename];
    self.player.delegate = self;
    self.playOrPauseButton.selected = YES;
    
    // 记录正在播放的音乐
    self.playingMusic = [SRMusicTool playingMusic];
    
    self.singerLabel.text = music.singer; // 歌手名称
    self.songLabel.text = music.name; // 歌曲名称
    //self.iconView.image = [UIImage imageNamed:music.icon]; // 背景图片
    self.durationLabel.text = [self strWithTimeInterval:self.player.duration]; // 音乐时长
    self.lrcView.lrcname = self.playingMusic.lrcname; // 切换歌词
    
    [self addProgressTimer];
    [self addLrcTimer];
    
    [self updateLockedScreenMusic];
}

- (NSString *)strWithTimeInterval:(NSTimeInterval)interval
{
    // 秒数转为指定格式的字符串
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d:%02d", m , s];
}

#pragma mark - 定时器

- (void)addProgressTimer
{
    if (self.player.playing == NO) {
        return;
    }
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)updateCurrentProgress
{
    double progress = self.player.currentTime / self.player.duration;
    double sliderMaxX = self.view.width - self.slider.width;
    self.slider.x = sliderMaxX * progress;
    
    [self.slider setTitle:[self strWithTimeInterval:self.player.currentTime] forState:UIControlStateNormal];
    self.progressView.width = self.slider.center.x; // 进度条的宽度
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addLrcTimer
{
    if (self.player.isPlaying == NO || self.lrcView.hidden) {
        return;
    }
    [self removeLrcTimer];
    [self updateLrc];
    [self setLrcTimer:[CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)]];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    [self setLrcTimer:nil];
}

- (void)updateLrc
{
    self.lrcView.currentTime = self.player.currentTime;
}

#pragma mark - 播放控制

- (IBAction)previous
{
    [self resetPlayingMusic]; // 重置数据
    self.slider.x = 0;
    self.progressView.width = 0;
    
    [SRMusicTool setPlayingMusic:[SRMusicTool previouesMusic]]; // 设置当前播放的音乐
    
    [self startPlayingMusic]; // 开始播放
}

- (IBAction)next
{
    [self resetPlayingMusic];
    self.slider.x = 0;
    self.progressView.width = 0;
    
    [SRMusicTool setPlayingMusic:[SRMusicTool nextMusic]];

    [self startPlayingMusic];
}

- (IBAction)playOrPause
{
    if (self.playOrPauseButton.selected) {
        // 暂停
        self.playOrPauseButton.selected = NO;
        [SRAudioTool pauseMusicWithFilename:self.playingMusic.filename];
        [self removeProgressTimer];
        [self removeLrcTimer];
    } else {
        // 播放
        self.playOrPauseButton.selected = YES;
        [SRAudioTool playMusicWithFilename:self.playingMusic.filename];
        [self addProgressTimer];
        [self addLrcTimer];
        [self updateLockedScreenMusic];
    }
}

#pragma mark - 手势事件

- (IBAction)onProgressBgTap:(UITapGestureRecognizer *)sender {
    
    CGPoint point =  [sender locationInView:sender.view]; // 点击的位置
    self.slider.x = point.x;
    
    double progress = point.x / sender.view.width; // 计算进度
    self.player.currentTime = progress * self.player.duration; // 设置播放时间
    [self updateCurrentProgress];
    [self updateLockedScreenMusic];
}

- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender
{
    // 滑块平移的位置
    CGPoint point =  [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    self.slider.x += point.x; // 累加平移的位置
    
    // 矫正位置
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    if (self.slider.x < 0) {
        self.slider.x = 0;
    } else if (self.slider.x > sliderMaxX) {
        self.slider.x = sliderMaxX;
    }
    
    self.progressView.width = self.slider.center.x; // 设置进度条的宽度
    //double progress = self.slider.x / (self.view.width - self.slider.width); // 这里计算错误是因为上面计算比例的总长度不一致导致
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = progress * self.player.duration;
    
    [self.slider setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal]; // 设置拖拽时滑块的标题
    [self.currentTime setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal]; // 设置辅助时间小方块
    self.currentTime.x = self.slider.x;
    self.currentTime.y = self.currentTime.superview.height - self.currentTime.height - 5;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始拖拽停止定时器, 显示辅助时间小方块
        self.currentTime.hidden = NO;
        [self removeProgressTimer];
        [self removeLrcTimer];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // 结束拖拽开启定时器, 隐藏辅助时间小方块
        self.currentTime.hidden = YES;
        self.player.currentTime = time; // 更新播放时间
        if (self.player.playing) {
            [self addProgressTimer];
            [self addLrcTimer];
        }
    }
    
    [self updateLockedScreenMusic];
}

#pragma mark - 顶部导航按钮点击

- (IBAction)exitBtnClick:(UIButton *)sender
{
    [self removeProgressTimer];
    [self removeLrcTimer];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = window.bounds.size.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}

- (IBAction)lrcOrPic:(UIButton *)sender {
    if (self.lrcView.isHidden) {
        // 显示歌词界面
        self.lrcView.hidden = NO;
        sender.selected = YES;
        [self addLrcTimer];
    } else {
        // 隐藏歌词界面
        self.lrcView.hidden = YES;
        sender.selected = NO;
        [self removeLrcTimer];
    }
}

#pragma mark - AVAudioPlayerDelegate

// 播放器结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next]; // 播放下一曲
}

// 播放器被打断时调用(例如电话)
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if (self.player.playing) {
        //[SRAudioTool pauseMusicWithFilename:self.playingMusic.filename];
        [self playOrPause]; // 暂停播放
    }
}

// 播放器被打断结束时调用
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (!self.player.playing) {
        [self startPlayingMusic]; // 继续播放
    }
}

#pragma mark - 锁屏界面

- (void)updateLockedScreenMusic
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionary];
    nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.playingMusic.name; // 专辑名称
    nowPlayingInfo[MPMediaItemPropertyArtist] = self.playingMusic.singer; // 歌手
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.playingMusic.name; // 歌曲名称
    nowPlayingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic.icon]]; // 设置图片
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration); // 总时间
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime); // 当前时间
    center.nowPlayingInfo = nowPlayingInfo;
    
    // 事件类型:
    // 1.远程控制事件 Remote Control Event
    // 2.加速计事件 Motion Event
    // 3.触摸事件 Touch Event
    
    // 监听远程控制事件
    [self becomeFirstResponder]; // 需要成为第一响应者
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents]; // 开始监控
}

#pragma mark - 远程控制事件监听

- (BOOL)canBecomeFirstResponder
{
    return YES; // default is NO
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self playOrPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
        default:
            break;
    }
}

@end
