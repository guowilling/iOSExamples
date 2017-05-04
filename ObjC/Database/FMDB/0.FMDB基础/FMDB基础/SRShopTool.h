//
//  SRShopTool.h
//  FMDB基础
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRShop;

@interface SRShopTool : NSObject

+ (NSArray *)shops;

+ (void)addShop:(SRShop *)shop;

+ (void)deleteShop:(float)price;

@end
