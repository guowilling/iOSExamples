//
//  NSObject+Calculator.h
//  链式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateManager.h"

@interface NSObject (Calculator)

+ (NSInteger)sr_makeCalculate:(void(^)(CalculateManager *manager))block;

@end
