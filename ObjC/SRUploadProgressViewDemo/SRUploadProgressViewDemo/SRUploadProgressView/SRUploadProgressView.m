//
//  UploadProgressView.m
//  SRUploadProgressViewDemo
//
//  Created by 郭伟林 on 16/8/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRUploadProgressView.h"
#import "BallProgressView.h"
#import "WaveProgressView.h"

@interface SRUploadProgressView ()

@property (nonatomic, strong) BallProgressView *ballProgressView;

@property (nonatomic, strong) WaveProgressView *waveProgressView;

@end

@implementation SRUploadProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

- (void)setType:(ProgressType)type {
    
    switch (type) {
        case ProgressTypeBall:
        {
            _ballProgressView = [[BallProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            _ballProgressView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
            [self addSubview:_ballProgressView];
            
            UILabel *tipsLabel      = [[UILabel alloc] init];
            tipsLabel.text          = @"正在上传...";
            tipsLabel.textColor     = [UIColor whiteColor];
            tipsLabel.font          = [UIFont systemFontOfSize:15];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.frame         = CGRectMake(0, CGRectGetMaxY(_ballProgressView.frame), self.frame.size.width, 40);
            [self addSubview:tipsLabel];
        }
            break;
            
        case ProgressTypeWave:
        {
            _waveProgressView = [[WaveProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            _waveProgressView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
            _waveProgressView.firstWaveColor  = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:34/255.0 alpha:1.0];
            _waveProgressView.secondWaveColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:34/255.0 alpha:0.5];
            [self addSubview:_waveProgressView];
            
            UILabel *tipsLabel      = [[UILabel alloc] init];
            tipsLabel.text          = @"正在上传...";
            tipsLabel.textColor     = [UIColor whiteColor];
            tipsLabel.font          = [UIFont systemFontOfSize:15];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.frame         = CGRectMake(0, CGRectGetMaxY(_waveProgressView.frame), self.frame.size.width, 40);
            [self addSubview:tipsLabel];
        }
            break;
    }
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    if (_ballProgressView) {
        _ballProgressView.progress = progress;
    }
    if (_waveProgressView) {
        _waveProgressView.progress = progress;
    }
}

@end
