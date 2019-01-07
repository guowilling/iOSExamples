//
//  ViewController.m
//  GradientCircularProgressView
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "GradientCircularProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) GradientCircularProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    self.progressView = [[GradientCircularProgressView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 125, [UIScreen mainScreen].bounds.size.height * 0.5 - 125, 250, 250)];
    self.progressView.progressTopGradientColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:0/255.0 alpha:1.0];
    self.progressView.progressMidGradientColor = [UIColor colorWithRed:255/255.0 green:38/255.0 blue:84/255.0 alpha:1.0];
    self.progressView.progressBottomGradientColor = [UIColor colorWithRed:255/255.0 green:114/255.0 blue:20/255.0 alpha:1.0];
    [self.view addSubview:self.progressView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)updateProgress {
    self.progressView.progress += 0.05;
    
    NSMutableAttributedString *mAString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.f%%", self.progressView.progress * 100]];
    [mAString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:100] range:NSMakeRange(0, mAString.length)];
    [mAString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:10] range:NSMakeRange(mAString.length - 1, 1)];
    self.progressView.progressLabel.attributedText = mAString;
    if (self.progressView.progress >= 0.99) {
        self.progressView.progress = 0;
    }
}

@end
