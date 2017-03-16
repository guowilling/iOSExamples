//
//  UIImage+Extension.m
//  CornerRadiusImage
//
//  Created by Willing Guo on 2017/3/14.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/// 平均耗时 0.05
- (UIImage *)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor {
    
    NSTimeInterval start = CACurrentMediaTime();
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [fillColor setFill];
    UIRectFill(rect);
    
    CGFloat radius = MIN(size.width, size.height) * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [path addClip];
    
    [self drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSLog(@"%f", CACurrentMediaTime() - start);
    
    return resultImage;
}

/// 平均耗时 0.05
- (void)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimeInterval start = CACurrentMediaTime();
        
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        [fillColor setFill];
        UIRectFill(rect);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [path addClip];
        
        [self drawInRect:rect];
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

// 注意: 不要使用此种方式剪切圆形图片, 会造成卡顿, 反而不如直接使用 layer.cornerRadius layer.masksToBounds, 原因目前不知道...
/// 平均耗时 0.55s!!!
+ (instancetype)circleImageWithImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor {
    
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
