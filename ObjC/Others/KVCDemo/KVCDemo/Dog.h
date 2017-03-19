//
//  Dog.h
//  kVC
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bone;

@interface Dog : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Bone *bone;

@end
