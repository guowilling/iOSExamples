//
//  FMBarrageModel.h
//  SRBarrageFactoryDemo
//
//  Created by 郭伟林 on 2017/8/2.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBarrageModelProtocol.h"

@interface FMBarrageModel : NSObject <SRBarrageModelDelegate>

@property (nonatomic, assign) NSTimeInterval launchTime;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) NSMutableAttributedString *content;

@property (nonatomic, copy) NSString *avatarURLString;

@end
