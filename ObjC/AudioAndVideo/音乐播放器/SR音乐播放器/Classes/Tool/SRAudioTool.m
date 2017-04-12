//
//  SRAudioTool.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

// AVAudioPlayer                : 只能播放本地音频文件
// AVPlayer                     : 能播放远程/本地 音频/视频文件
// MPMoviePlayerController      : 能播放远程/本地 音频/视频文件
// MPMoviePlayerViewController  : 能播放远程/本地 音频/视频文件

#import "SRAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation SRAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

+ (void)initialize
{
    // 后台播放设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}

+ (NSMutableDictionary *)soundIDs
{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}

+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

+ (void)playAudioWithFilename:(NSString *)filename
{
    if (!filename) {
        return;
    }
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (!soundID) {
        NSLog(@"创建新的soundID");
        NSURL *URL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!URL) {
            return;
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(URL), &soundID);
        [self soundIDs][filename] = @(soundID);
    }
    // Plays a system sound object.
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeAudioWithFilename:(NSString *)filename
{
    if (!filename) {
        return;
    }
    
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (soundID) {
        // Disposes of a system sound object and associated resources.
        AudioServicesDisposeSystemSoundID(soundID);
        [[self soundIDs] removeObjectForKey:filename];
    }
}

+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    if (!filename) {
        return nil;
    }
    
    AVAudioPlayer *player = [self players][filename];
    if (!player) {
        NSLog(@"创建新的播放器");
        NSURL *URL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!URL) {
            return nil;
        }
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:nil];
        if(![player prepareToPlay]) {
            return nil;
        }
        [self players][filename] = player;
        //player.enableRate = YES;
        //player.rate = 3;
    }
    
    if (!player.isPlaying) {
        [player play];
    }
    return player;
}

+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    if (!filename) {
        return;
    }
    AVAudioPlayer *player = [self players][filename];
    if (!player) {
        return;
    }
    if (player.playing) {
        [player pause];
    }
}

+ (void)stopMusicWithFilename:(NSString  *)filename
{
    if (!filename) {
        return;
    }
    AVAudioPlayer *player = [self players][filename];
    if (!player) {
        return;
    }
    [player stop];
    [[self players] removeObjectForKey:filename]; // 移除播放器, 播放器调用了停止就没有用了.
}

@end
