//
//  SRAudioPlayer.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioPlayer.h"
#import "SRAudioResourceLoader.h"
#import <AVFoundation/AVFoundation.h>

@interface SRAudioPlayer ()

@property (nonatomic, assign) BOOL isUserPaused;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) SRAudioResourceLoader *audioResourceLoader;

@end

@implementation SRAudioPlayer

static SRAudioPlayer *_shareInstance;

+ (instancetype)shareInstance {
    
    if (!_shareInstance) {
        _shareInstance = [[SRAudioPlayer alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return _shareInstance;
}

- (NSURL *)streamingURL:(NSURL *)URL {
    
    NSURLComponents *compents = [NSURLComponents componentsWithString:URL.absoluteString];
    compents.scheme = @"sreaming";
    return compents.URL;
}

- (void)playWithURL:(NSURL *)URL {
    
    NSURL *currentURL = [(AVURLAsset *)self.player.currentItem.asset URL];
    if ([URL isEqual:currentURL] || [[self streamingURL:URL] isEqual:currentURL]) {
        [self resume];
        return;
    }
    if (self.player.currentItem) {
        [self removeObserver];
    }
    URL = [self streamingURL:URL];
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    asset = [AVURLAsset assetWithURL:URL];
    self.audioResourceLoader = [SRAudioResourceLoader new];
    [asset.resourceLoader setDelegate:self.audioResourceLoader queue:dispatch_get_main_queue()];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterupt) name:AVPlayerItemPlaybackStalledNotification object:item];
    self.player = [AVPlayer playerWithPlayerItem:item];
}

- (void)pause {
    
    [self.player pause];
    
    _isUserPaused = YES;
    
    if (self.player) {
        self.state = SRAudioPlayerStatePaused;
    }
}

- (void)resume {
    
    [self.player play];
    
    _isUserPaused = NO;
    
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.state = SRAudioPlayerStatePlaying;
    }
}

- (void)stop {
    
    [self.player pause];
    self.player = nil;
    
    if (self.player) {
        self.state = SRAudioPlayerStateStopped;
    }
}

- (void)seekWithTimeInterval:(NSTimeInterval)interval {
    
    NSTimeInterval totalTimeSec = [self totalTime];
    NSTimeInterval playTimeSec = [self currentTime];
    playTimeSec += interval;
    [self seekWithProgress:playTimeSec / totalTimeSec];
}

- (void)seekWithProgress:(float)progress {
    
    if (progress < 0 || progress > 1) {
        return;
    }

    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    NSTimeInterval playTimeSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(playTimeSec, 1);
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) { }];
}

- (BOOL)muted {
    
    return self.player.muted;
}

- (void)setRate:(float)rate {
    
    [self.player setRate:rate];
}

- (float)rate {
    
    return self.player.rate;
}

- (void)setMuted:(BOOL)muted {
    
    self.player.muted = muted;
}

- (float)volume {
    
    return self.player.volume;
}

- (void)setVolume:(float)volume {
    
    if (volume < 0 || volume > 1) {
        return;
    }
    if (volume > 0) {
        [self setMuted:NO];
    }
    self.player.volume = volume;
}

- (NSTimeInterval)totalTime {
    
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}

- (NSString *)totalTimeFormat {
    
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.totalTime / 60, (int)self.totalTime % 60];
}

- (NSTimeInterval)currentTime {
    
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}

- (NSString *)currentTimeFormat {
    
    return [NSString stringWithFormat:@"%02zd:%02zd", (int)self.currentTime / 60, (int)self.currentTime % 60];
}

- (float)playingProgress {
    
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}

- (float)cachingProgress {
    
    if (self.totalTime == 0) {
        return 0;
    }
    
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    return loadTimeSec / self.totalTime;
}

- (void)playEnd {
    
    self.state = SRAudioPlayerStateStopped;
}

- (void)playInterupt {

    self.state = SRAudioPlayerStatePaused;
}

- (void)setState:(SRAudioPlayerState)state {
    
    _state = state;
}

- (void)removeObserver {
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            [self resume];
        } else {
            self.state = SRAudioPlayerStateFailed;
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL ptk = [change[NSKeyValueChangeNewKey] boolValue];
        if (ptk) {
            if (!_isUserPaused) {
                [self resume];
            }
        } else {
            self.state = SRAudioPlayerStateLoading;
        }
    }
}

@end
