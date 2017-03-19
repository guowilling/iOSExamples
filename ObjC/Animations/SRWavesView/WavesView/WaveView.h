//
//  WaveView.h
//  WavesView
//
//  Created by 郭伟林 on 17/2/14.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WaveDirection) {
    WaveDirectionForward,
    WaveDirectionBackward,
};

@interface WaveView : UIView

@property (assign, nonatomic) WaveDirection waveDirection;

@property (nonatomic, strong) UIColor *waveColor;
@property (nonatomic, assign) CGFloat  waveHSpeed;
@property (nonatomic, assign) CGFloat  waveVSpeed;

- (void)startWave;

- (void)stopWave;

@end
