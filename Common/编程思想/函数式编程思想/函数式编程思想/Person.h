//
//  Person.h
//  函数式编程思想
//
//  Created by Willing Guo on 2018/8/5.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (void)run;
- (void)eat;

- (Person *)run1;
- (Person *)eat1;

- (Person * (^)())run2;
- (Person * (^)())eat2;

- (Person * (^)(double distance))run3;
- (Person * (^)(NSString *food))eat3;

@end
