//
//  Singleton.m
//  BySingleton
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (instancetype)shared {
    
    static Singleton *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
