//
//  ViewController.m
//  GradientProgressView
//
//  Created by Willing Guo on 16/12/10.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "GradientProgressView.h"

@interface ViewController ()

@property (strong, nonatomic) GradientProgressView *gradientProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"GradientProgressView";
    
    _gradientProgressView = [[GradientProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 5)];
    [self.view addSubview:_gradientProgressView];
    
    // Starts the moving gradient effect
    [_gradientProgressView startAnimating];
    
    // Continuously updates the progress value using random values
    [self simulateUpdateProgress];
}

- (void)simulateUpdateProgress {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat progress = _gradientProgressView.progress + 0.2;
        _gradientProgressView.progress = progress;
        if (progress < 1.0) {
            [self simulateUpdateProgress];
        } else {
            [_gradientProgressView removeFromSuperview];
        }
    });
}

@end
