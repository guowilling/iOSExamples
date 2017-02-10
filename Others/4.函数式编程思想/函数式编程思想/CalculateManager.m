//
//  CalculateManager.m
//  函数式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager

+ (instancetype)sharedManager {
    
    static CalculateManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CalculateManager new];
    });
    return manager;
}

- (instancetype)calculate:(NSInteger (^)(NSInteger result))calculateHandler {
    
    _result = 0;
    _result = calculateHandler(_result);
    return self;
}

@end
