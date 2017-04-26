//
//  ViewController.m
//  ElegantCircleProgressDemo
//
//  Created by 郭伟林 on 17/4/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "ElegantCircleProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) ElegantCircleProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat circleWidth = [UIScreen mainScreen].bounds.size.width - 100;
    _progressView = [[ElegantCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
    _progressView.center = self.view.center;
    [self.view addSubview:_progressView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_progressView.frame) + 50, self.view.bounds.size.width - 2 * 50, 20)];
    [slider setMinimumValue:0];
    [slider setMaximumValue:1];
    [slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [slider setMaximumTrackTintColor:[UIColor grayColor]];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

- (void)sliderChanged:(UISlider*)slider {
    
    _progressView.progress = slider.value;
}

@end
