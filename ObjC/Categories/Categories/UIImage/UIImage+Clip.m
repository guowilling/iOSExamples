//
//  UIImage+Clip.m
//  SRCategory
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)

- (instancetype)subImageInRect:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect subBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(subBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subBounds, subImageRef);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return subImage;
}

- (instancetype)cropImageAtFrame:(CGRect)frame {
    frame = CGRectMake(frame.origin.x * self.scale,
                       frame.origin.y * self.scale,
                       frame.size.width * self.scale,
                       frame.size.height * self.scale);
    CGImageRef sourceImageRef  = self.CGImage;
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(sourceImageRef, frame);
    UIImage *croppedImage      = [UIImage imageWithCGImage:croppedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(croppedImageRef);
    return croppedImage;
}

@end
