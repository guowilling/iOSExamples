//
//  ViewController.m
//  CircularProgressDemo
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "CircularProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) CircularProgressView *progressView;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _progressView = [[CircularProgressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 - 50, self.view.frame.size.height * 0.5 - 50,
                                                                             100, 100)];
    _progressView.progressTintColor = [UIColor blueColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_progressView addGestureRecognizer:tap];
    [self.view addSubview:_progressView];
    
    [self startTimer];
    
}

- (void)startTimer {
    
    if (self.updateTimer) {
        [self.updateTimer invalidate];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    });
}

- (void)updateProgress:(NSTimer *)timer {
    
    if (self.progressView.progress >= 1) {
        self.progressView.progress = 0;
        [self startTimer];
    } else {
        [self.progressView setProgress:self.progressView.progress + 1.0/60/15  animated:YES];
    }
}

- (void)tapAction {
    
    self.progressView.progress = 0;
    [self startTimer];
}

@end
