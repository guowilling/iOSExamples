//
//  UILabel+Swizzling.m
//  SRCategory
//
//  Created by 郭伟林 on 17/1/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UILabel+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation UILabel (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(setFont:) swizzledSelector:@selector(hookSetFont:)];
    });
}

- (void)hookSetFont:(UIFont *)font {
    
    //[self hookSetFont:[UIFont fontWithName:font.fontName size:font.pointSize]];
    
    CGFloat adjustFontSize = font.pointSize / 375.0 * [UIScreen mainScreen].bounds.size.width;
    NSString *adjustFontName = @"PingFangSC-Light";
    [self hookSetFont:[UIFont fontWithName:adjustFontName size:adjustFontSize]];
}

@end
