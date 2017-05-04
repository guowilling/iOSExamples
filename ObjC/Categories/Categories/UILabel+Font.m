//
//  UILabel+Font.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UILabel+Font.h"
#import <objc/runtime.h>

@implementation UILabel (Font)

+ (void)load {
    
    //[super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldImp = class_getInstanceMethod([self class], @selector(setFont:));
        Method newImp = class_getInstanceMethod([self class], @selector(hookSetFont:));
        method_exchangeImplementations(oldImp, newImp);
    });
}

- (void)hookSetFont:(UIFont *)font {
    
    //CGFloat adjustFontSize = font.pointSize / 375.0 * [UIScreen mainScreen].bounds.size.width;
    //NSString *adjustFontName = @"PingFangSC-Light";
    [self hookSetFont:[UIFont fontWithName:font.fontName size:font.pointSize]];
}

- (UIFont *)adjustFont {
    
    return self.font;
}

- (void)setAdjustFont:(UIFont *)adjustFont {
    
    CGFloat adjustFontSize = adjustFont.pointSize / 375.0 * [UIScreen mainScreen].bounds.size.width;
    NSString *fontName = adjustFont.fontName;
    self.font = [UIFont fontWithName:fontName size:adjustFontSize];
}

@end
