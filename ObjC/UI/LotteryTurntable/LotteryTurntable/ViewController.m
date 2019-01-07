//
//  ViewController.m
//  LotteryTurntable
//
//  Created by 郭伟林 on 15/9/23.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"

@interface ViewController ()

@property (nonatomic, weak) WheelView *wheelView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wheelView = [WheelView wheel];
    _wheelView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:_wheelView];
}

- (IBAction)start:(id)sender {
    [self.wheelView startRotating];
}

- (IBAction)stop:(id)sender {
    [self.wheelView stopRotating];
}

@end
