//
//  Student.h
//  OCBlock
//
//  Created by Willing Guo on 17/1/15.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

- (Student *(^)(NSString *name))study;
- (Student *(^)())run;

@end
