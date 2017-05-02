//
//  CALayer+Extension.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Extension)

+ (UIImage *)imageWithLayer:(CALayer *)targetLayer;

+ (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame;
+ (CAGradientLayer *)backgroundGradientLayerWithFrame:(CGRect)frame StartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors;

@end
