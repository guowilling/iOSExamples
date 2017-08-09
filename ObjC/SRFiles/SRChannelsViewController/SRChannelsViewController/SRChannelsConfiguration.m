//
//  SRChannelsBarConfiguration.m
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRChannelsConfiguration.h"

@interface SRChannelsConfiguration ()

@property (nonatomic, strong, readwrite) UIColor *barBackgroundColor;

@property (nonatomic, strong, readwrite) UIColor *channelNormalColor;
@property (nonatomic, strong, readwrite) UIColor *channelSelectedColor;
@property (nonatomic, strong, readwrite) UIFont  *channelFont;

@property (nonatomic, strong, readwrite) UIColor *indicatorViewColor;
@property (nonatomic, assign, readwrite) CGFloat  indicatorViewHeight;
@property (nonatomic, assign, readwrite) CGFloat  indicatorViewExtraWidth;

@property (nonatomic, strong, readwrite) UIColor *bottomLineViewColor;

@end

@implementation SRChannelsConfiguration

+ (instancetype)defaultConfig {
    
    SRChannelsConfiguration *config = [[SRChannelsConfiguration alloc] init];
    config.barBackgroundColor = [UIColor clearColor];
    
    config.channelNormalColor = [UIColor grayColor];
    config.channelSelectedColor = [UIColor blackColor];
    config.channelFont = [UIFont systemFontOfSize:15];
    
    config.indicatorViewColor = [UIColor blackColor];
    config.indicatorViewHeight = 2;
    config.indicatorViewExtraWidth = 2;
    
    config.bottomLineViewColor = [UIColor lightGrayColor];
    
    return config;
}

- (SRChannelsConfiguration *(^)(UIColor *))backgroundColor {
    
    return ^(UIColor *color) {
        self.barBackgroundColor = color;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(UIColor *))titleNormalColor {
    
    return ^(UIColor *color) {
        self.channelNormalColor = color;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(UIColor *))titleSelectedColor {
    
    return ^(UIColor *color) {
        self.channelSelectedColor = color;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(UIFont *))titleFont {
    
    return ^(UIFont *font) {
        self.channelFont = font;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(UIColor *))indicatorColor {
    
    return ^(UIColor *color) {
        self.indicatorViewColor = color;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(CGFloat))indicatorHeight {
    
    return ^(CGFloat height) {
        self.indicatorViewHeight = height;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(CGFloat))indicatorExtraWidth {
    
    return ^(CGFloat width) {
        self.indicatorViewExtraWidth = width;
        return self;
    };
}

- (SRChannelsConfiguration *(^)(UIColor *))bottomLineColor {
    
    return ^(UIColor *color) {
        self.bottomLineViewColor = color;
        return self;
    };
}

@end
