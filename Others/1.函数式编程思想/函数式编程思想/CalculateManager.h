//
//  CalculateManager.h
//  函数式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateManager : NSObject

@property (nonatomic, assign) NSInteger result;

@property (nonatomic, assign) BOOL isEqual;

+ (instancetype)sharedManager;

- (instancetype)calculate:(NSInteger (^)(NSInteger result))calculateHandler;

- (instancetype)isEqualTo:(BOOL (^)(NSInteger result))equleHandler;

@end
