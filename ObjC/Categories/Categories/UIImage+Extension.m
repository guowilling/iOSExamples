//
//  UIImage+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIImage+Extension.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Resize.h"

@implementation UIImage (Extension)

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)videoFirstImageWithVideoPath:(NSString *)videoPath {
    if (!videoPath || videoPath.length == 0) {
        return nil;
    }
    AVURLAsset *urlAsset                               = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    AVAssetImageGenerator *assetImageGenerator         = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.requestedTimeToleranceBefore   = kCMTimeZero;
    assetImageGenerator.requestedTimeToleranceAfter    = kCMTimeZero;
    CMTime time         = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    CGImageRef imageRef = [assetImageGenerator copyCGImageAtTime:time actualTime:NULL error:nil];
    if (imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return image;
    } else {
        return nil;
    }
}

- (NSData *)imageCompressedToMost32KData {
    static CGFloat kMaxImageDataLength = 32 * 1024.0;
    CGFloat quality = 1.0;
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    NSUInteger dataLength = data.length;
    if (dataLength > kMaxImageDataLength) {
        quality = 1.0 - kMaxImageDataLength / dataLength;
    }
    return UIImageJPEGRepresentation(self, quality);
}

+ (NSData *)wxShareThumbnail:(UIImage *)thumbImage {
    static CGFloat kMaxImageDataLength = 32 * 1024.0;
    NSData *thumbData = UIImageJPEGRepresentation(thumbImage, 0.9);
    BOOL flag = thumbData.length > kMaxImageDataLength;
    while (flag) {
        thumbImage = [thumbImage resizeImageToSize:CGSizeMake(thumbImage.size.width * 0.9, thumbImage.size.height * 0.9)];
        thumbData = UIImageJPEGRepresentation(thumbImage, 0.9);
        flag = thumbData.length > kMaxImageDataLength;
    }
    return thumbData;
}

- (UIColor *)averageColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if (rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

@end
