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

    NSInteger result = [[CalculateManager sharedManager] calculate:^NSInteger(NSInteger result) {
        result += 5;
        result -= 2;
        result *= 5;
        result /= 2;
        return result;
    }].result;
    NSLog(@"%zd", result);
}

@end
