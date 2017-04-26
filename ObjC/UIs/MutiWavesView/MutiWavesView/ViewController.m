//
//  ViewController.m
//  MutiWavesView
//
//  Created by 郭伟林 on 17/2/14.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"

#define UICOLOR_FROM_HEX_ALPHA(RGBValue, Alpha) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:Alpha]

#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_WIDTH            SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT           SCREEN_BOUNDS.size.height
#define SCREEN_ADJUST(Value)    ceilf(SCREEN_HEIGHT * (Value) / 667.0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view.layer addSublayer:[self backgroundGradientLayerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255)]];
    
    CGRect waveRect = CGRectMake(0, 255 - 15, SCREEN_WIDTH, 15);
    
    WaveView *waveView0 = [[WaveView alloc] initWithFrame:waveRect];
    [self.view addSubview:({
        waveView0.waveColor = UICOLOR_FROM_HEX_ALPHA(0x870016, 0.3);
        waveView0.waveDirection = WaveDirectionBackward;
        waveView0.waveVSpeed = 1.0;
        waveView0.waveHSpeed = 0.5;
        waveView0;
    })];
    [waveView0 startWave];
    
    WaveView *waveView1 = [[WaveView alloc] initWithFrame:waveRect];
    [self.view addSubview:({
        waveView1.waveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        waveView1.waveDirection = WaveDirectionForward;
        waveView1.waveVSpeed = 1.0;
        waveView1.waveHSpeed = 0.75;
        waveView1;
    })];
    [waveView1 startWave];
    
    WaveView *waveView2 = [[WaveView alloc] initWithFrame:waveRect];
    [self.view addSubview:({
        waveView2.waveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        waveView2.waveDirection = WaveDirectionBackward;
        waveView2.waveVSpeed = 1.0;
        waveView2.waveHSpeed = 1.0;
        waveView2;
    })];
    [waveView2 startWave];
    
    WaveView *waveView3 = [[WaveView alloc] initWithFrame:waveRect];
    [self.view addSubview:({
        waveView3.waveColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        waveView3.waveDirection = WaveDirectionForward;
        waveView3.waveVSpeed = 1.0;
        waveView3.waveHSpeed = 1.25;
        waveView3;
    })];
    [waveView3 startWave];
}

- (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame {
    
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(1.0, 0.0);
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:(id)[UIColor colorWithRed:255/255.0 green:212/255.0  blue:99/255.0 alpha:1.0].CGColor];
    [colors addObject:(id)[UIColor colorWithRed:250/255.0 green:97/255.0  blue:162/255.0 alpha:1.0].CGColor];
    return [self backgroundGradientLayerWithFrame:frame StartPoint:startPoint endPoint:endPoint colors:colors];
}

- (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame StartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = colors;
    return gradientLayer;
}

@end
