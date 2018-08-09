//
//  ViewController.m
//  链式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Calculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger result = [NSObject sr_makeCalculate:^(CalculateManager *manager) {
        // 5 - 2 = 3 * 5 = 15 / 2 = 7.
        manager.addition(5).subtraction(2).multiplication(5).division(2);
    }];
    NSLog(@"%zd", result);
}

@end
