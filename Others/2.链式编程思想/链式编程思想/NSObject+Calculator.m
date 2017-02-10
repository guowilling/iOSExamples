//
//  NSObject+Calculator.m
//  链式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "NSObject+Calculator.h"

@implementation NSObject (Calculator)

+ (NSInteger)sr_makeCalculate:(void(^)(CalculateManager *manager))block {
    
    CalculateManager *manager = [CalculateManager new];
    block(manager);
    return manager.result;
}

@end
