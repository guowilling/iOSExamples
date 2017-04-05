//
//  UIImageView+Swizzling.m
//  RuntimeSwizzlingDemo
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImageView+Swizzling.h"
#import <objc/runtime.h>

@implementation UIImageView (Swizzling)

+ (void)load {
    
    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(hook_setImage:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

/// Reset image's size to imageView's size.
- (void)hook_setImage:(UIImage *)image {
    
    NSLog(@"%s\noriginal image: %@", __FUNCTION__, image);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [image drawInRect:self.bounds]; // Draws the entire image in the specified rectangle, scaling it as needed to fit.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self hook_setImage:result];
}

@end
