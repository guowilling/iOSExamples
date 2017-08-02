//
//  Student.m
//  SRSqliteExtension
//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "Student.h"

@implementation Student

+ (NSString *)primaryKey {
    
    return @"stuNum";
}

+ (NSArray *)ignoreIvarsNames {
    
    return @[@"tmp"];
}

@end
