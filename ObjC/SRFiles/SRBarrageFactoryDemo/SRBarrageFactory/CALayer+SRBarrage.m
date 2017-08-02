//
//  CALayer+SRBarrage.m
//  SRBarrageFactory
//
//  Created by 郭伟林 on 2017/7/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CALayer+SRBarrage.h"

@implementation CALayer (SRBarrage)

- (void)pauseAnimation {
    
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimation {
    
    CFTimeInterval pausedTime = self.timeOffset;
    self.timeOffset = 0.0;
    self.speed = 1.0;
    self.beginTime = 0.0;
    CFTimeInterval timeIntervalPaused = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeIntervalPaused;
}

@end
