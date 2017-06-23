//
//  ViewController.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAudioPlayer.h"

#define kNetworkURL [NSURL URLWithString:@"http://yxfile.idealsee.com/media01/04fc34c5e39f549731c01d98a94dcaf2_mp3-full.mp3"]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)play {
    
    [[SRAudioPlayer shareInstance] playWithURL:kNetworkURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
