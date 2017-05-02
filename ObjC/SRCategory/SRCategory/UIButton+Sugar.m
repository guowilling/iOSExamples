//
//  UIButton+Sugar.m
//  SRCategory
//
//  Created by 郭伟林 on 17/4/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIButton+Sugar.h"

@implementation UIButton (Sugar)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector {
    
    return [self buttonWithFrame:frame title:title target:target selector:selector image:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector image:(NSString*)image {
    
    return [self buttonWithFrame:frame title:title target:target selector:selector image:image imagePressed:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector image:(NSString*)image imagePressed:(NSString *)imagePressed {
    
    return [self buttonWithFrame:frame title:title target:target selector:selector image:image imagePressed:imagePressed imageSelected:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector image:(NSString*)image imagePressed:(NSString *)imagePressed imageSelected:(NSString *)imageSelected {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (imagePressed) {
        [button setImage:[UIImage imageNamed:imagePressed] forState:UIControlStateHighlighted];
    }
    if (imageSelected) {
        [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }
    return button;
}

@end
