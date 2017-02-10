//
//  CalculateManager.m
//  链式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager

- (CalculateManager * (^)(int))addition {
    
    return ^(int value) {
        _result += value;
        return self;
    };
}

- (CalculateManager * (^)(int))subtraction {
    
    return ^(int value) {
        _result -= value;
        return self;
    };
}

- (CalculateManager * (^)(int))multiplication {
    
    return ^(int value) {
        _result *= value;
        return self;
    };
}

- (CalculateManager * (^)(int))division {
    
    return ^(int value) {
        _result /= value;
        return self;
    };
}

@end
