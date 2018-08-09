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
    NSLog(@"%d", (int)isEqual);
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    Person *person = [Person new];
//    
//    [person eat];
//    [person run];
//    
//    NSLog(@"----------");
//    [[person eat1] run1];
//    
//    NSLog(@"----------");
//    person.eat2().run2();
//    person.run2().eat2();
//    
//    NSLog(@"----------");
//    person.eat3(@"some").run3(1000);
//    person.run3(1000).eat3(@"some");
//}

@end
