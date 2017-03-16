//
//  UIImage+Extension.h
//  CornerRadiusImage
//
//  Created by Willing Guo on 2017/3/14.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor;

- (void)cornerRadiusImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor
                       completion:(void (^)(UIImage *image))completion;

+ (instancetype)circleImageWithImage:(UIImage *)originalImage borderWidth:(NSInteger)borderWidth borderColor:(UIColor *)borderColor;

@end
