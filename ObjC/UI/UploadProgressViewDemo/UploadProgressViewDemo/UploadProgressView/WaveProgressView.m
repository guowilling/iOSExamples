//
//  WaveProgressView.m
//  UploadProgressViewDemo
//
//  Created by 郭伟林 on 16/8/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#define LXDefaultFirstWaveColor   [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:1.0]
#define LXDefaultSecondWaveColor  [UIColor colorWithRed:34/255.0 green:116/255.0 blue:210/255.0 alpha:0.5]
#define LXWaveBorderColor         [UIColor colorWithRed:244/255.0 green:244/255.0 blue:248/255.0 alpha:1].CGColor
#define LXWaveBorderWidth  2.0

#import "WaveProgressView.h"
#import "YYWeakProxy.h"

@interface WaveProgressView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;

@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat offsetX;

@end

@implementation WaveProgressView

- (void)dealloc {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    if (_firstWaveLayer) {
        [_firstWaveLayer removeFromSuperlayer];
        _firstWaveLayer = nil;
    }
    if (_secondWaveLayer) {
        [_secondWaveLayer removeFromSuperlayer];
        _secondWaveLayer = nil;
    }
}

- (CAShapeLayer *)firstWaveLayer {
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.frame = self.bounds;
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondWaveLayer {
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.frame = self.bounds;
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
    }
    return _secondWaveLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel               = [[UILabel alloc] init];
        _progressLabel.text          = @"0%";
        _progressLabel.frame         = CGRectMake(0, 0, self.bounds.size.width, 30);
        _progressLabel.center        = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _progressLabel.font          = [UIFont systemFontOfSize:20];
        _progressLabel.textColor     = [UIColor colorWithWhite:0 alpha:1];
        _progressLabel.textAlignment = 1;
    }
    return _progressLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height));
        self.layer.cornerRadius  = MIN(frame.size.width, frame.size.height) * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor   = LXWaveBorderColor;
        self.layer.borderWidth   = LXWaveBorderWidth;
        
        _waveSpeed  = 1.0;
        _waveAmplitude = 5.0;
        _firstWaveColor  = LXDefaultFirstWaveColor;
        _secondWaveColor = LXDefaultSecondWaveColor;
        _waveHeight = self.bounds.size.height;
        
        [self.layer addSublayer:self.firstWaveLayer];
        if (!self.isSingleWave) {
            [self.layer addSublayer:self.secondWaveLayer];
        }
        [self addSubview:self.progressLabel];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _waveHeight = self.bounds.size.height * (1 - progress);
    
    _progressLabel.text = [NSString stringWithFormat:@"%zd%%",[[NSNumber numberWithFloat:progress * 100] integerValue]];
    _progressLabel.textColor=[UIColor colorWithWhite:progress*1.8 alpha:1];
    
    [self stopWaveAnimation];
    [self startWaveAnimation];
}

- (void)startWaveAnimation {
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self]
                                                       selector:@selector(waveAnimation)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopWaveAnimation {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)waveAnimation {
    CGFloat waveHeight = self.waveAmplitude;
    if (self.progress == 0.0f || self.progress == 1.0f) {
        waveHeight = 0.f;
    }
    
    self.offsetX += self.waveSpeed;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGFloat startOffY = waveHeight * sinf(self.offsetX * M_PI * 2 / self.bounds.size.width);
    CGFloat orignOffY = 0.0;
    CGPathMoveToPoint(pathRef, NULL, 0, startOffY);
    for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
        orignOffY = waveHeight * sinf(2 * M_PI / self.bounds.size.width * i + self.offsetX * 2 * M_PI / self.bounds.size.width) + self.waveHeight;
        CGPathAddLineToPoint(pathRef, NULL, i, orignOffY);
    }
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, orignOffY);
    CGPathAddLineToPoint(pathRef, NULL, self.bounds.size.width, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, self.bounds.size.height);
    CGPathAddLineToPoint(pathRef, NULL, 0, startOffY);
    CGPathCloseSubpath(pathRef);
    self.firstWaveLayer.path = pathRef;
    self.firstWaveLayer.fillColor = self.firstWaveColor.CGColor;
    CGPathRelease(pathRef);
    
    if (!self.isSingleWave) {
        CGMutablePathRef pathRef1 = CGPathCreateMutable();
        CGFloat startOffY = waveHeight * sinf(self.offsetX * M_PI * 2 / self.bounds.size.width);
        CGFloat orignOffY = 0.0;
        CGPathMoveToPoint(pathRef1, NULL, 0, startOffY);
        for (CGFloat i = 0.f; i <= self.bounds.size.width; i++) {
            orignOffY = waveHeight * cosf(2 * M_PI / self.bounds.size.width * i + self.offsetX * 2 * M_PI / self.bounds.size.width) + self.waveHeight;
            CGPathAddLineToPoint(pathRef1, NULL, i, orignOffY);
        }
        CGPathAddLineToPoint(pathRef1, NULL, self.bounds.size.width, orignOffY);
        CGPathAddLineToPoint(pathRef1, NULL, self.bounds.size.width, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef1, NULL, 0, self.bounds.size.height);
        CGPathAddLineToPoint(pathRef1, NULL, 0, startOffY);
        CGPathCloseSubpath(pathRef1);
        self.secondWaveLayer.path = pathRef1;
        self.secondWaveLayer.fillColor = self.secondWaveColor.CGColor;
        CGPathRelease(pathRef1);
    }
}

@end
