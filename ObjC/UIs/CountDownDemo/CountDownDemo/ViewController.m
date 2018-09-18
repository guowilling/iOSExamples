//
//  ViewController.m
//  CountDownDemo
//
//  Created by 郭伟林 on 2017/6/30.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRCountDownLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [SRCountDownLabel startCountDownWithNumber:3];
    
//    [SRCountDownLabel startCountDownWithNumber:3 endTips:@"GO"];

    [SRCountDownLabel startCountDownWithNumber:3 endTips:@"GO" endBlock:^{
        NSLog(@"GO~GO~GO");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
