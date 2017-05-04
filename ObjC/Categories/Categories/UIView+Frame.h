//
//  UIView+Frame.h
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat sr_x;
@property (nonatomic, assign) CGFloat sr_y;
@property (nonatomic, assign) CGFloat sr_centerX;
@property (nonatomic, assign) CGFloat sr_centerY;
@property (nonatomic, assign) CGFloat sr_width;
@property (nonatomic, assign) CGFloat sr_height;
@property (nonatomic, assign) CGPoint sr_origin;
@property (nonatomic, assign) CGSize  sr_size;

@property (nonatomic, assign) CGFloat sr_top;
@property (nonatomic, assign) CGFloat sr_left;
@property (nonatomic, assign) CGFloat sr_bottom;
@property (nonatomic, assign) CGFloat sr_right;

@property (nonatomic, assign, readonly) CGPoint bottomLeft;
@property (nonatomic, assign, readonly) CGPoint bottomRight;
@property (nonatomic, assign, readonly) CGPoint topLeft;
@property (nonatomic, assign, readonly) CGPoint topRight;
@property (nonatomic, assign, readonly) CGPoint middle;

@end
