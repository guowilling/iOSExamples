//
//  SRCustomButton.h
//  CustomButton
//
//  Created by 郭伟林 on 16/12/28.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonLayoutStyle) {
    LayoutStyleLeftImageRightTitle,
    LayoutStyleLeftTitleRightImage,
    LayoutStyleUpImageDownTitle,
    LayoutStyleUpTitleDownImage
};

@interface SRCustomButton : UIButton

@property (nonatomic, assign) ButtonLayoutStyle layoutStyle;

@property (nonatomic, assign) CGFloat marginBetweenImageAndTitle;

@property (nonatomic, assign) CGSize imageSize;

@end
