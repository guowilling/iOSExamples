//
//  SRHelp.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRHelp.h"

@implementation SRHelp

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.html = dict[@"html"];
        self.tag = dict[@"id"];
    }
    return self;
}

+ (instancetype)helpWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)helps {
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"json"]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray * arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self helpWithDict:dict]];
    }
    return arrayM;
}

@end
