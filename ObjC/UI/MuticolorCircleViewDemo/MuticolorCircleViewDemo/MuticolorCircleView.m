//
//  MuticolorCircleView.m
//  MuticolorCircleViewDemo
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "MuticolorCircleView.h"

@implementation MuticolorCircleView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMulticolorGradientLayer];
        self.layer.mask = [self produceCircleShapeLayer];
    }
    return self;
}

- (void)setupMulticolorGradientLayer {
    CAGradientLayer *gradientLayer = (id)[self layer];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 10) {
        [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
    }
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
}

- (CAShapeLayer *)produceCircleShapeLayer {
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                              radius:self.bounds.size.width/2.0 - 40
                                                          startAngle:0
                                                            endAngle:2 * M_PI
                                                           clockwise:NO];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.5;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    return shapeLayer;
}

#pragma mark - Animation

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 5;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSNumber numberWithDouble:0];
    animation.toValue = [NSNumber numberWithDouble:2 * M_PI];
    [self.layer addAnimation:animation forKey:@"transform"];
}

- (void)endAnimation {
    [self.layer removeAllAnimations];
}

@end
