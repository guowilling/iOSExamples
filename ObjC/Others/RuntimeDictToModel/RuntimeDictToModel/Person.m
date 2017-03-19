//
//  Person.m
//  RuntimeDictToModel
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)description {
    
    NSArray *keys = @[@"name", @"age", @"gender", @"profession"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
