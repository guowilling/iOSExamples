//
//  UIImage+Resize.h
//  SRCategory
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (instancetype)scaleWithFixedWidth:(CGFloat)width;
- (instancetype)scaleWithFixedHeight:(CGFloat)height;

+ (instancetype)resizeImage:(UIImage *)originalImage toSize:(CGSize)dstSize;
+ (instancetype)resizeImage:(UIImage *)originalImage toW:(CGFloat)dstW;

- (instancetype)resizeImageToSize:(CGSize)dstSize;

@end
