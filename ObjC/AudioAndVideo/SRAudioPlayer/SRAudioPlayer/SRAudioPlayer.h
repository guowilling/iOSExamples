//
//  SRAudioPlayer.h
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SRAudioPlayerState) {
    SRAudioPlayerStateUnknown,
    SRAudioPlayerStateLoading,
    SRAudioPlayerStatePlaying,
    SRAudioPlayerStatePaused,
    SRAudioPlayerStateStopped,
    SRAudioPlayerStateFailed
};

@interface SRAudioPlayer : NSObject

@property (nonatomic, assign) float volume;
@property (nonatomic, assign) float rate;
@property (nonatomic, assign) BOOL  muted;

@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, copy  , readonly) NSString *totalTimeFormat;
@property (nonatomic, copy  , readonly) NSString *currentTimeFormat;

@property (nonatomic, assign, readonly) float playingProgress;
@property (nonatomic, assign, readonly) float cachingProgress;

@property (nonatomic, assign, readonly) SRAudioPlayerState state;

+ (instancetype)shareInstance;

- (void)playWithURL:(NSURL *)URL;

- (void)pause;
- (void)resume;
- (void)stop;

- (void)seekWithTimeInterval:(NSTimeInterval)interval;
- (void)seekWithProgress:(float)progress;

@end
