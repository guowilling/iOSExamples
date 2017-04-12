//
//  GradientCircularProgressView.m
//  GradientCircularProgressView
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "GradientCircularProgressView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface GradientCircularProgressView ()
{
    UIImageView *_imageView;
    UILabel     *_label;
}
@end

@implementation GradientCircularProgressView

+ (void)initialize {
    
    if (self == [GradientCircularProgressView class]) {
        id appearance = [self appearance];
        [appearance setInnerBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
        [appearance setProgressTopGradientColor:[UIColor colorWithRed:74/255.0 green:200/255.0 blue:180/255.0 alpha:0.8]];
        [appearance setProgressMidGradientColor:[UIColor colorWithRed:255/255.0 green:155/255.0 blue:122/255.0 alpha:0.8]];
        [appearance setProgressBottomGradientColor:[UIColor colorWithRed:114.0/255.0 green:174.0/255.0 blue:235.0/255.0 alpha:1.0]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.frame = self.bounds;
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_progressLabel];
        
//        _imageView = [[UIImageView alloc] init];
//        _imageView.frame = self.bounds;
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.image = [UIImage imageNamed:@"redpacket_circle_progress"];
//        CABasicAnimation *transformRoate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        transformRoate.byValue = [NSNumber numberWithDouble:(2 * M_PI)];
//        transformRoate.duration = 2;
//        transformRoate.repeatCount = MAXFLOAT;
//        [_imageView.layer addAnimation:transformRoate forKey:nil];
//        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    CGFloat progressAngle = _progress * 360 - 90;
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2;
    CGRect  square = CGRectMake(0, 0, rect.size.width, rect.size.width);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (_outerBackgroundColor) {
        UIBezierPath *outerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius
                                                               startAngle:0.0
                                                                 endAngle:2*M_PI
                                                                clockwise:NO];
        [_outerBackgroundColor setStroke];
        [outerCircle stroke];
    }
    
    if (_innerBackgroundColor) {
        UIBezierPath *innerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius - 5
                                                               startAngle:2*M_PI
                                                                 endAngle:0.0
                                                                clockwise:NO];
        
        [_innerBackgroundColor setStroke];
        innerCircle.lineWidth = 6;
        [innerCircle stroke];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius - 3
                                                startAngle:DEGREES_TO_RADIANS(-90)
                                                  endAngle:DEGREES_TO_RADIANS(progressAngle)
                                                 clockwise:YES]];
    
    [path addArcWithCenter:center
                    radius:radius - 9
                startAngle:DEGREES_TO_RADIANS(progressAngle)
                  endAngle:DEGREES_TO_RADIANS(-90)
                 clockwise:NO];
    [path closePath];
    
    if (_progressFillColor) {
        [_progressFillColor setFill];
        [path fill];
    } else if (_progressTopGradientColor && _progressMidGradientColor && _progressBottomGradientColor) {
        [path addClip];
        NSArray *backgroundColors = @[(id)[_progressTopGradientColor CGColor],
                                      (id)[_progressMidGradientColor CGColor],
                                      (id)[_progressBottomGradientColor CGColor],
                                      ];
        CGFloat backgroudColorLocations[3] = {0.0f, 0.5f, 1.0f};
        CGColorSpaceRef spaceRef = CGColorSpaceCreateDeviceRGB();
        CGGradientRef backgroundGradient = CGGradientCreateWithColors(spaceRef, (__bridge CFArrayRef)(backgroundColors), backgroudColorLocations);
        CGContextDrawLinearGradient(context,
                                    backgroundGradient,
                                    CGPointMake(0.0f, square.origin.y),
                                    CGPointMake(0.0f, square.size.height),
                                    0);
        CGGradientRelease(backgroundGradient);
        CGColorSpaceRelease(spaceRef);
    }
    CGContextRestoreGState(context);
}

#pragma mark - UIAppearance

- (void)setInnerBackgroundColor:(UIColor *)innerBackgroundColor {
    
    _innerBackgroundColor = innerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setOuterBackgroundColor:(UIColor *)outerBackgroundColor {
    
    _outerBackgroundColor = outerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressFillColor:(UIColor *)progressFillColor {
    
    _progressFillColor = progressFillColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressTopGradientColor:(UIColor *)progressTopGradientColor {
    
    _progressTopGradientColor = progressTopGradientColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressMidGradientColor:(UIColor *)progressMidGradientColor {
    
    _progressMidGradientColor = progressMidGradientColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressBottomGradientColor:(UIColor *)progressBottomGradientColor {
    
    _progressBottomGradientColor = progressBottomGradientColor;
    
    [self setNeedsDisplay];
}

- (void)setProgress:(double)progress {
    
    _progress = MIN(1.0, MAX(0.0, progress));
    
    [self setNeedsDisplay];
}

@end
