//
//  Student.m
//  KVC
//
//  Created by 郭伟林 on 16/5/27.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "Student.h"

@implementation Student

//- (void)testPrivate {
//    // Use of undeclared identifier '_height'; did you mean '_weight'?
//    NSLog(@"%2.f", _height);
//}

- (void)testProtected {
    
    NSLog(@"%2.f", _age);
}

- (void)testPublic {
    
    NSLog(@"%2.f", _weight);
}

@end
