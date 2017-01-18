//
//  SRCustomButton.m
//  CustomButton
//
//  Created by 郭伟林 on 16/12/28.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRCustomButton.h"

@implementation SRCustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _marginBetweenImageAndTitle = 10;
        _imageSize = CGSizeZero;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    
    if (!CGSizeEqualToSize(CGSizeZero, self.imageSize)) {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageSize.width, self.imageSize.height);
    }
    
    switch (self.layoutStyle) {
        case LayoutStyleLeftImageRightTitle:
        {
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
        }
            break;
        case LayoutStyleLeftTitleRightImage:
        {
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
        }
            break;
        case LayoutStyleUpImageDownTitle:
        {
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
        }
            break;
        case LayoutStyleUpTitleDownImage:
        {
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
        }
            break;
    }
}

- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    
    CGRect leftViewFrame = leftView.frame;
    CGRect rightViewFrame = rightView.frame;
    
    CGFloat totalWidth = CGRectGetWidth(leftViewFrame) + self.marginBetweenImageAndTitle + CGRectGetWidth(rightViewFrame);
    
    leftViewFrame.origin.x = (CGRectGetWidth(self.frame) - totalWidth) / 2.0;
    leftViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(leftViewFrame)) / 2.0;
    leftView.frame = leftViewFrame;
    
    rightViewFrame.origin.x = CGRectGetMaxX(leftViewFrame) + self.marginBetweenImageAndTitle;
    rightViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rightViewFrame)) / 2.0;
    rightView.frame = rightViewFrame;
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    
    CGRect upViewFrame = upView.frame;
    CGRect downViewFrame = downView.frame;
    
    CGFloat totalHeight = CGRectGetHeight(upViewFrame) + self.marginBetweenImageAndTitle + CGRectGetHeight(downViewFrame);
    
    upViewFrame.origin.y = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
    upViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(upViewFrame)) / 2.0;
    upView.frame = upViewFrame;
    
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame) + self.marginBetweenImageAndTitle;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(downViewFrame)) / 2.0;
    downView.frame = downViewFrame;
}

#pragma mark - Public Methods

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    
    [self setNeedsLayout];
}

- (void)setMarginBetweenImageAndTitle:(CGFloat)marginBetweenImageAndTitle {
    
    _marginBetweenImageAndTitle = marginBetweenImageAndTitle;
    
    [self setNeedsLayout];
}

- (void)setImageSize:(CGSize)imageSize {
    
    _imageSize = imageSize;

    [self setNeedsLayout];
}

@end
