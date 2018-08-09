//
//  Person.m
//  函数式编程思想
//
//  Created by Willing Guo on 2018/8/5.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)run {
    NSLog(@"%s", __func__);
}

- (void)eat {
    NSLog(@"%s", __func__);
}

- (Person *)run1 {
    NSLog(@"%s", __func__);
    return self;
}

- (Person *)eat1 {
    NSLog(@"%s", __func__);
    return self;
}

- (Person * (^)())run2 {
    Person * (^runBlock)() = ^ {
        NSLog(@"run2");
        return self;
    };
    return runBlock;
}

- (Person *(^)())eat2 {
    return ^ {
        NSLog(@"eat2");
        return self;
    };
}

- (Person *(^)(double))run3 {
    return ^(double distance) {
        NSLog(@"run3 %f", distance);
        return self;
    };
}

- (Person *(^)(NSString *))eat3 {
    return ^(NSString *food) {
        NSLog(@"eat3 %@", food);
        return self;
    };
}

@end
