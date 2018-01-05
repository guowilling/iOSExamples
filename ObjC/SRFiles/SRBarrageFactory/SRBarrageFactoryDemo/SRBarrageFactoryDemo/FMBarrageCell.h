//
//  FMBarrageCell.h
//  SRBarrageFactoryDemo
//
//  Created by 郭伟林 on 2017/8/2.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBarrageModel.h"

@interface FMBarrageCell : UIView

+ (instancetype)barrageCell;

@property (nonatomic, strong) FMBarrageModel *barrageModel;

@property (nonatomic, copy) void (^setupAvatarBlock)(UIImageView *avtar, NSString *avatarURLString);

@end
