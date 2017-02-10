//
//  SRSettingGroup.h
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSettingGroup : NSObject

@property (nonatomic, strong) NSArray *settingItems;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@end
