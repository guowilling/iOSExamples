//
//  ShimmeringLabel.h
//  ShimmeringLabel
//
//  Created by Willing Guo on 2017/4/5.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShimmeringType) {
    ShimmeringLeftToRight,
    ShimmeringRightToLeft,
    ShimmeringAutoReverse,
    ShimmeringFull
};

@interface ShimmeringLabel : UIView

// UILabel properties.
@property (strong, nonatomic) NSString           *text;
@property (strong, nonatomic) UIFont             *font;
@property (strong, nonatomic) UIColor            *textColor;
@property (strong, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSInteger           numberOfLines;

// ShimmerLabel properties.
@property (assign, nonatomic) ShimmeringType shimmeringType;
@property (assign, nonatomic) BOOL           infiniteLoop;
@property (assign, nonatomic) CGFloat        shimmeringWidth;      // 闪烁宽度, 默认 20
@property (assign, nonatomic) CGFloat        shimmeringRadius;     // 闪烁半径, 默认 20
@property (assign, nonatomic) NSTimeInterval shimmeringDuration;   // 闪烁时间, 默认两秒
@property (strong, nonatomic) UIColor       *shimmeringColor;      // 闪烁颜色, 默认白色

- (void)startShimmering;
- (void)stopShimmering;

@end
