//
//  HMShop.h
//  FMDB存储对象类型
//
//  Created by 郭伟林 on 16/3/23.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRShop : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGFloat price;

@end
