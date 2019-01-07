//
//  UIImage+Rounding.h
//  ImageCornerRadiusDemo
//
//  Created by 郭伟林 on 2017/7/25.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rounding)

+ (instancetype)roundedImageWithOriginalImage:(UIImage *)originalImage destSize:(CGSize)destSize fillColor:(UIColor *)fillColor;

+ (void)roundingImageWithOriginalImage:(UIImage *)originalImage destSize:(CGSize)destSize fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *roundedImage))completion;

+ (instancetype)roundedImageWithOriginalImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor;

@end
