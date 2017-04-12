//
//  SRMusicTool.m
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRMusicTool.h"
#import "SRMusic.h"
#import "MJExtension.h"

@implementation SRMusicTool

static NSArray *_musics; // 所有音乐

static SRMusic *_playingMusic; // 正在播放的音乐

+ (NSArray *)musics
{
    if (!_musics) {
        _musics = [SRMusic objectArrayWithFilename:@"mp3.plist"];
    }
    return _musics;
}

+ (void)setPlayingMusic:(SRMusic *)music
{
    if (!music || ![[self musics] containsObject:music]) {
        return;
    }
    _playingMusic = music;
}

+ (SRMusic *)playingMusic
{
    return _playingMusic;
}

+ (SRMusic *)nextMusic
{
    NSUInteger currentIndex = [[self musics] indexOfObject:_playingMusic];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex >= [[self musics] count]) {
        nextIndex = 0;
    }
    return [self musics][nextIndex];
}

+ (SRMusic *)previouesMusic
{
    NSUInteger currentIndex = [[self musics] indexOfObject:_playingMusic];
    NSInteger perviouesIndex = currentIndex - 1;
    if (perviouesIndex < 0) {
        perviouesIndex = [[self musics] count] - 1;
    }
    return [self musics][perviouesIndex];
}

@end
