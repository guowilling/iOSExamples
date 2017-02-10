//
//  SRSettingArrowItem.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRSettingArrowItem.h"

@implementation SRSettingArrowItem

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title destClass:(Class)destClass {
    
    if (self = [super initWithIcon:icon title:title])  {
        self.destClass = destClass;
    }
    return self;
}

@end
