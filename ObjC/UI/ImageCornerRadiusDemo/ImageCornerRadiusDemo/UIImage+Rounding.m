//
//  UIImage+Rounding.m
//  ImageCornerRadiusDemo
//
//  Created by 郭伟林 on 2017/7/25.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImage+Rounding.h"

@implementation UIImage (Rounding)

/// 平均耗时 0.05
+ (instancetype)roundedImageWithOriginalImage:(UIImage *)originalImage destSize:(CGSize)destSize fillColor:(UIColor *)fillColor {
    NSTimeInterval start = CACurrentMediaTime();
    UIGraphicsBeginImageContextWithOptions(destSize, YES, 0);
    CGRect rect = CGRectMake(0, 0, destSize.width, destSize.height);
    [fillColor setFill];
    UIRectFill(rect);
    CGFloat radius = MIN(destSize.width, destSize.height) * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    [originalImage drawInRect:rect];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%f", CACurrentMediaTime() - start);
    return roundedImage;
}

/// 平均耗时 0.05
+ (void)roundingImageWithOriginalImage:(UIImage *)originalImage destSize:(CGSize)destSize fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *roundedImage))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimeInterval start = CACurrentMediaTime();
        UIGraphicsBeginImageContextWithOptions(destSize, YES, 0);
        CGRect rect = CGRectMake(0, 0, destSize.width, destSize.height);
        [fillColor setFill];
        UIRectFill(rect);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        [originalImage drawInRect:rect];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"%f", CACurrentMediaTime() - start);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(resultImage);
            }
        });
    });
}

/// 平均耗时 0.55s!!! 注意: 不要使用此种方式剪切圆形图片, 会造成卡顿, 反而不如直接使用 layer.cornerRadius layer.masksToBounds, 原因目前不知道...
+ (instancetype)roundedImageWithOriginalImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor {
    NSTimeInterval start = CACurrentMediaTime();
    
    CGSize size = CGSizeMake(originalImage.size.width + borderWidth, originalImage.size.height + borderWidth);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0); // 创建图形上下文, YES 不透明; NO 透明
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(contextRef, CGRectMake(0, 0, size.width, size.height)); // 外圆
    [borderColor set];
    CGContextFillPath(contextRef);
    
    CGFloat smallX = borderWidth * 0.5;
    CGFloat smallY = borderWidth * 0.5;
    CGFloat smallW = originalImage.size.width;
    CGFloat smallH = originalImage.size.height;
    CGContextAddEllipseInRect(contextRef, CGRectMake(smallX, smallY, smallW, smallH)); // 内圆
    [[UIColor clearColor] set];
    
    // 绘制, As a side effect when you call this function, Quartz clears the current path.
    // CGContextFillPath(ctx);
    
    // 裁剪, Modifies the current clipping path, 已经绘制的内容不受影响, After determining the new clipping path, the function resets the context’s current path to an empty path.
    CGContextClip(contextRef);
    
    [originalImage drawInRect:CGRectMake(smallX, smallY, smallW, smallH)];
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"%f", CACurrentMediaTime() - start);
    
    return circleImage;
}

@end
