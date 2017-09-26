//
//  SRAudioPlayer.m
//  RecordAudioSImpleCode
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SRAudioPlayer ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation SRAudioPlayer

SRSingletonImplement(SRAudioPlayer)

- (void)playAudioWithPath:(NSString *)path {
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
    
    [_player prepareToPlay];
    
    [_player play];
}

- (void)pause {
    
    [self.player pause];
}

- (void)resume {
    
    [self.player play];
}

- (void)stop {
    
    [self.player stop];
}

- (void)setVolumn:(CGFloat)volumn {
    
    self.player.volume = volumn;
}

- (CGFloat)playProgress {
    
    return self.player.currentTime / self.player.duration;
}

@end
