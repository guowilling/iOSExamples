//
//  UITextView+SRExtension.h
//  UITextViewExtension
//
//  Created by 郭伟林 on 2017/6/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (SRExtension)

@property (nonatomic, copy  ) NSString *placeholder;
@property (nonatomic, strong) UIColor  *placeholderColor;

@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;

@end
