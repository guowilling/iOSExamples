//
//  ViewController.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkAction {
    NSLog(@"currentTimeFormat: %@, cachingProgress: %.2f", [SRAudioPlayer shareInstance].currentTimeFormat, [SRAudioPlayer shareInstance].cachingProgress);
}

- (IBAction)play {
    NSURL *testURL = [NSURL URLWithString:@"http://yxfile.idealsee.com/media01/04fc34c5e39f549731c01d98a94dcaf2_mp3-full.mp3"];
    [[SRAudioPlayer shareInstance] playWithURL:testURL];
}

@end
