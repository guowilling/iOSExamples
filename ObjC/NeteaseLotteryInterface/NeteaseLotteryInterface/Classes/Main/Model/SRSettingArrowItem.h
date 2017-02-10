//
//  SRSettingArrowItem.h
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRSettingItem.h"

@interface SRSettingArrowItem : SRSettingItem

@property (nonatomic, assign) Class destClass;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title destClass:(Class)destClass;

@end
