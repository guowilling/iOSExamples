//
//  CALayer+Extension.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

+ (UIImage *)imageWithLayer:(CALayer *)targetLayer {
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    UIGraphicsBeginImageContextWithOptions(targetLayer.frame.size, NO, [UIScreen mainScreen].scale);
    [targetLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"imageWithLayer cost time: %.2f", CFAbsoluteTimeGetCurrent() - start);
    
    return image;
}

+ (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame {
    
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(1.0, 0.0);
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:(id)[UIColor colorWithRed:255/255.0 green:212/255.0  blue:99/255.0 alpha:1.0].CGColor];
    [colors addObject:(id)[UIColor colorWithRed:250/255.0 green:97/255.0  blue:162/255.0 alpha:1.0].CGColor];
    return [self backgroundGradientLayerWithFrame:frame StartPoint:startPoint endPoint:endPoint colors:colors];
}

+ (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame StartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = colors;
    return gradientLayer;
}

@end
