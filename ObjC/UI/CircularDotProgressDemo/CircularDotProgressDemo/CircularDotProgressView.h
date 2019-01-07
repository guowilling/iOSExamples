//
//  CircularProgressView.h
//  CircularDotProgressDemo
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularDotProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIColor *progressTintColor;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
