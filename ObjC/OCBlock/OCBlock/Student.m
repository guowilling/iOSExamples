//
//  Student.m
//  OCBlock
//
//  Created by Willing Guo on 17/1/15.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "Student.h"

@implementation Student

- (Student *(^)(NSString *))study {
    
    return ^(NSString *name) {
        NSLog(@"study: %@", name);
        return self;
    };
}

- (Student *(^)())run {
    
    return ^{
        NSLog(@"run");
        return self;
    };
}

@end
