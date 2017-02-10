//
//  WheelButton.m
//  LotteryTurntable
//
//  Created by 郭伟林 on 15/9/23.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "WheelButton.h"

@implementation WheelButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = (contentRect.size.width - kImageWidth) * 0.5;
    CGFloat imageY = 30;
    return CGRectMake(imageX, imageY, kImageWidth, kImageHeight);
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
