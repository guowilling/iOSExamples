//
//  CircularProgressView.m
//  CircularDotProgressDemo
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CircularDotProgressView.h"

#define DEGREES_TO_RADIANS(x) (x) / 180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x) / M_PI*180.0

@interface CircularProgressViewBackgroundLayer : CALayer

@property (nonatomic, strong) UIColor *tintColor;

@end

@implementation CircularProgressViewBackgroundLayer

- (id)init {
    
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    
    _tintColor = tintColor;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    CGContextSetFillColorWithColor(ctx, _tintColor.CGColor);
    CGFloat WH = self.bounds.size.width * 0.3;
    CGContextFillRect(ctx, CGRectMake(CGRectGetMidX(self.bounds) - WH * 0.5, CGRectGetMidY(self.bounds) - WH * 0.5, WH, WH));
    
    CGContextSetStrokeColorWithColor(ctx, _tintColor.CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, 1, 1));
}

@end

@interface CircularDotProgressView ()

@property (nonatomic, strong) CircularProgressViewBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation CircularDotProgressView
{
    UIColor *_progressTintColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _progressTintColor = [UIColor blackColor];
    
    // Set up the background layer.
    _backgroundLayer = [[CircularProgressViewBackgroundLayer alloc] init];
    _backgroundLayer.frame = self.bounds;
    _backgroundLayer.tintColor = self.progressTintColor;
    [self.layer addSublayer:_backgroundLayer];
    
    // Set up the shape layer.
    _shapeLayer = [[CAShapeLayer alloc] init];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor = _progressTintColor.CGColor;
    [self.layer addSublayer:_shapeLayer];
    
    [self startIndeterminateAnimation];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    _progress = progress;
    
    if (progress > 0) {
        BOOL startingFromIndeterminateState = [self.shapeLayer animationForKey:@"indeterminateAnimation"] != nil;
        [self stopIndeterminateAnimation];
        
        self.shapeLayer.lineWidth = 3;
        self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                              radius:self.bounds.size.width/2 - 2
                                                          startAngle:3*M_PI_2
                                                            endAngle:3*M_PI_2 + 2*M_PI
                                                           clockwise:YES].CGPath;
        if (animated) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = (startingFromIndeterminateState) ? @0 : nil;
            animation.toValue = [NSNumber numberWithFloat:progress];
            animation.duration = 1;
            self.shapeLayer.strokeEnd = progress;
            [self.shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        } else {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.shapeLayer.strokeEnd = progress;
            [CATransaction commit];
        }
    } else { // If progress is zero add the indeterminate animation.
        [self.shapeLayer removeAnimationForKey:@"strokeEndAnimation"];
        [self startIndeterminateAnimation];
    }
}

- (void)setProgress:(CGFloat)progress {
    
    [self setProgress:progress animated:NO];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    
    _progressTintColor = progressTintColor;
    
    _backgroundLayer.tintColor = progressTintColor;
    
    _shapeLayer.strokeColor = progressTintColor.CGColor;
}

- (UIColor *)progressTintColor {
    
    return _progressTintColor;
}

#pragma mark - Indeterminate Animation

- (void)startIndeterminateAnimation {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.hidden = YES;
    self.shapeLayer.lineWidth = 1;
    self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                          radius:self.bounds.size.width/2 - 1
                                                      startAngle:DEGREES_TO_RADIANS(345)
                                                        endAngle:DEGREES_TO_RADIANS(15)
                                                       clockwise:NO].CGPath;
    self.shapeLayer.strokeEnd = 1;
    [CATransaction commit];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"indeterminateAnimation"];
}

- (void)stopIndeterminateAnimation {
    
    [self.shapeLayer removeAnimationForKey:@"indeterminateAnimation"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.backgroundLayer.hidden = NO;
    [CATransaction commit];
}

@end
