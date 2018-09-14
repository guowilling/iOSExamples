//
//  UIImageView+Extension.m
//  SRCategory
//
//  Created by 郭伟林 on 17/2/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImageView+Extension.h"
#import <objc/runtime.h>

@implementation UIImageView (Extension)

+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(hook_setImage:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)hook_setImage:(UIImage *)image {
    NSLog(@"%s\nimage: %@", __FUNCTION__, image);
    // 调整 image 的大小为 imageView 的大小
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [image drawInRect:self.bounds];
    UIImage *sizeFitImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self hook_setImage:sizeFitImage];
}

- (void)clipImageWithRadius:(CGFloat)radius {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    if (currnetContext) {
        CGContextAddPath(currnetContext, [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath);
        CGContextClip(currnetContext);
        [self.layer renderInContext:currnetContext];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    self.image = image;
}

- (void)clipImageToRound {
    [self clipImageWithRadius:self.bounds.size.width * 0.5];
}

@end
