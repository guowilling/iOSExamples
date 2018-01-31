//
//  UIButton+Sugar.h
//  SRCategory
//
//  Created by 郭伟林 on 17/4/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Sugar)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector image:(NSString*)image;
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector image:(NSString*)image imagePressed:(NSString *)imagePressed;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        image:(NSString*)image
                 imagePressed:(NSString *)imagePressed
                imageSelected:(NSString *)imageSelected;

@end
