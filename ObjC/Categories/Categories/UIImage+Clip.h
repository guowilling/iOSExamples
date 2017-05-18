//
//  UIImage+Clip.h
//  SRCategory
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)

- (UIImage *)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor;

- (void)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;

+ (instancetype)circleImageWithImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor;

- (instancetype)subImageInRect:(CGRect)rect;
- (instancetype)croppedImageAtFrame:(CGRect)frame;

@end
