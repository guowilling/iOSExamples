//
//  SRBarrageProtocol.h
//  SRBarrageFactory
//
//  Created by 郭伟林 on 2017/7/31.
//  Copyright © 2017年 SR. All rights reserved.
//

@protocol SRBarrageModelDelegate <NSObject>

@property (nonatomic, readonly) NSTimeInterval launchTime;

@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly) NSMutableAttributedString *content;

@end
