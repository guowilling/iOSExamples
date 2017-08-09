//
//  SRChannelsBarConfiguration.h
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRChannelsConfiguration : NSObject

+ (instancetype)defaultConfig;

@property (nonatomic, strong, readonly) UIColor *barBackgroundColor;

@property (nonatomic, strong, readonly) UIColor *channelNormalColor;
@property (nonatomic, strong, readonly) UIColor *channelSelectedColor;
@property (nonatomic, strong, readonly) UIFont  *channelFont;

@property (nonatomic, strong, readonly) UIColor *indicatorViewColor;
@property (nonatomic, assign, readonly) CGFloat  indicatorViewHeight;
@property (nonatomic, assign, readonly) CGFloat  indicatorViewExtraWidth;

@property (nonatomic, strong, readonly) UIColor *bottomLineViewColor;

@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^backgroundColor)(UIColor *color);

@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^titleNormalColor)(UIColor *color);
@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^titleSelectedColor)(UIColor *color);
@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^titleFont)(UIFont *font);

@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^indicatorColor)(UIColor *color);
@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^indicatorHeight)(CGFloat height);
@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^indicatorExtraWidth)(CGFloat width);

@property (nonatomic, copy, readonly) SRChannelsConfiguration *(^bottomLineColor)(UIColor *color);

@end
