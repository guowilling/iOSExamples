//
//  ViewController.m
//  函数式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "CalculateManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    BOOL isEqual = [[[CalculateManager sharedManager] calculate:^NSInteger(NSInteger result) {
        result += 5;
        result -= 2;
        result *= 5;
        result /= 2;
        return result;
    }] isEqualTo:^BOOL(NSInteger result) {
        return result == 7;
    }].isEqual;
    NSLog(@"%zd", isEqual);
}

@end
