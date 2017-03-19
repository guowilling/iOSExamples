//
//  WaveView.m
//  WavesView
//
//  Created by 郭伟林 on 17/2/14.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (nonatomic, assign) CGFloat        waveOffsetX;
@property (nonatomic, strong) CADisplayLink *waveDisplayLink;
@property (nonatomic, strong) CAShapeLayer  *waveShapeLayer;

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _waveHSpeed = 2.0f;
        _waveVSpeed = 1.0f;
        _waveColor  = [UIColor whiteColor];
    }
    return self;
}

- (void)startWave {
    
    if (self.waveShapeLayer) {
        return;
    }
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWaveShapeLayer)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateWaveShapeLayer {
    
    switch (self.waveDirection) {
        case WaveDirectionForward: {
            self.waveOffsetX += self.waveHSpeed;
            break;
        }
        case WaveDirectionBackward: {
            self.waveOffsetX -= self.waveHSpeed;
            break;
        }
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height / 2);
    
    CGFloat y = 0.f;
    for (CGFloat x = 0.f; x <= width; x++) {
        y = height * sin(0.02 * (self.waveVSpeed * x + self.waveOffsetX));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.waveShapeLayer.path = path;
    CGPathRelease(path);
}

- (void)stopWave {
    
    if (!self.waveDisplayLink) {
        return;
    }
    [UIView animateWithDuration:1.f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.waveDisplayLink invalidate];
        self.waveDisplayLink = nil;
        self.waveShapeLayer = nil;
        self.alpha = 1.0;
    }];
}

@end
