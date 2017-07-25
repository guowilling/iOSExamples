//
//  UIImageView+SRCornerRadius.h
//  ImageCornerRadiusDemo
//
//  Created by 郭伟林 on 2017/7/25.
//  Copyright © 2017年 SR. All rights reserved.
//
//  感谢原作者 liuzhiyi1992: https://github.com/liuzhiyi1992/ZYCornerRadius
//

#import <UIKit/UIKit.h>

@interface UIImageView (SRCornerRadius)

+ (instancetype)sr_advanceImageViewWithCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;
+ (instancetype)sr_advanceRoundingRectImageView;

- (void)sr_advanceCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners;
- (void)sr_advanceRoundingRect;

- (void)sr_attachBorderWithWidth:(CGFloat)width color:(UIColor *)color;

@end
