//
//  SRSettingItem.h
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum
//{
//    ProductItemTypeArrow,
//    ProductItemTypeSwitch
//}ProductItemType;

//typedef enum {
//    SettingItemShowTypePush,
//    SettingItemShowTypeModal
//}SettingItemShowType;

//@property (nonatomic, assign) SettingItemShowType showType;
//@property (nonatomic, assign) ProductItemType type;

typedef void (^optionBlock)();

@interface SRSettingItem : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) optionBlock option;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title;

@end
