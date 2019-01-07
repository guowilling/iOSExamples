//
//  ViewController.m
//  AdjustNumberButton
//
//  Created by 郭伟林 on 2017/7/24.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "AdjustNumberButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AdjustNumberButton *adjustNumberButton = [[AdjustNumberButton alloc] init];
    adjustNumberButton.frame = CGRectMake(0, 0, 120, 30);
    adjustNumberButton.center = self.view.center;
    adjustNumberButton.currentNumberDidChangeBlock = ^(NSString *currentNumber) {
        NSLog(@"%@", currentNumber);
    };
    [self.view addSubview:adjustNumberButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
