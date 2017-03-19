//
//  ViewController.m
//  VariableArgumentDemo
//
//  Created by 郭伟林 on 16/8/16.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

int add(int firstNum, ...)
{
    int sum = 0;
    int number = firstNum;
    va_list argumentList;
    va_start(argumentList, firstNum);
    while(1) {
        printf("number = %d\n", number);
        sum += number;
        number = va_arg(argumentList, int);
        if (number == 0) {
            break;
        }
    }
    va_end(argumentList);
    return sum;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //printf("sum is %d\n", add(1, 2, 3, 4, 5, 0));
    
    [self variableArgumentsMethod:@"Hello", @"World", @"!", nil];
}

- (void)variableArgumentsMethod:(NSString *)arg1, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSMutableArray *stringArray = [NSMutableArray array];
    va_list args;
    va_start(args, arg1);
    if(arg1) {
        NSLog(@"%@", arg1);
        [stringArray addObject:arg1];
        NSString *nextArg;
        while((nextArg = va_arg(args, NSString *))) {
            [stringArray addObject:nextArg];
            NSLog(@"%@", nextArg);
        }
    }
    NSLog(@"%@", stringArray);
    va_end(args);
}

@end
