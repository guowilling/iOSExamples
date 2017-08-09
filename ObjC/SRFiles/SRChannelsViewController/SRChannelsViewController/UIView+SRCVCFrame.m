//
//  UIView+SRCVC.m
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIView+SRCVCFrame.h"

@implementation UIView (SRCVCFrame)

- (CGFloat)srcvc_x {
    
    return self.frame.origin.x;
}

- (void)setSrcvc_x:(CGFloat)srcvc_x {
    
    CGRect frame = self.frame;
    frame.origin.x = srcvc_x;
    self.frame = frame;
}


- (CGFloat)srcvc_y {
    
    return self.frame.origin.y;
}

- (void)setSrcvc_y:(CGFloat)srcvc_y {
    
    CGRect frame = self.frame;
    frame.origin.y = srcvc_y;
    self.frame = frame;
}

- (CGFloat)srcvc_width {
    
    return self.frame.size.width;
}

- (void)setSrcvc_width:(CGFloat)srcvc_width {
    
    CGRect frame = self.frame;
    frame.size.width = srcvc_width;
    self.frame = frame;
}

- (CGFloat)srcvc_height {
    
    return self.frame.size.height;
}

- (void)setSrcvc_height:(CGFloat)srcvc_height {
    
    CGRect frame = self.frame;
    frame.size.height = srcvc_height;
    self.frame = frame;
}

- (CGFloat)srcvc_centerX {
    
    return self.center.x;
}

- (void)setSrcvc_centerX:(CGFloat)srcvc_centerX {
    
    CGPoint center = self.center;
    center.x = srcvc_centerX;
    self.center = center;
}

- (CGFloat)srcvc_centerY {
    
    return self.center.y;
}

- (void)setSrcvc_centerY:(CGFloat)srcvc_centerY {
    
    CGPoint center = self.center;
    center.y = srcvc_centerY;
    self.center = center;
}

@end
