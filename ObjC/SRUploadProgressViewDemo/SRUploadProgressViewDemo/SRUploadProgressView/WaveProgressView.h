//
//  WaveProgressView.h
//  SRUploadProgressViewDemo
//
//  Created by 郭伟林 on 16/8/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveProgressView : UIView

@property (nonatomic, assign) CGFloat  progress;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, assign) CGFloat waveSpeed;
@property (nonatomic, assign) CGFloat waveAmplitude;

@property (nonatomic, strong) UIColor *firstWaveColor;
@property (nonatomic, strong) UIColor *secondWaveColor;

@property (nonatomic, assign, getter=isOnlySingleWave) BOOL onlySingleWave;

@end
