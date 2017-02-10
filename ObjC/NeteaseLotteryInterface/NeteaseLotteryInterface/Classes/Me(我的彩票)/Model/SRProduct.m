//
//  SRProduct.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRProduct.h"

@implementation SRProduct

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
        self.appUrl = dict[@"url"];
        self.schemes = dict[@"customUrl"];
        self.identifier = dict[@"id"];
    }
    return self;
}

+ (instancetype)productWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)products {
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"products" ofType:@"json"]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", array);
    NSMutableArray * arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self productWithDict:dict]];
    }
    return arrayM;
}

@end
