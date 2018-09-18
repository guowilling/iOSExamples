//
//  BossHeaderRefresh.m
//  BossHeaderRefreshDemo
//
//  Created by 郭伟林 on 17/2/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "BossHeaderRefresh.h"
#import "UIView+SRFrame.h"

const CGFloat SURefreshHeaderHeight = 30.0;
const CGFloat SURefreshPointRadius  = 5.0;
const CGFloat SURefreshTranslatLen  = 2.5;
const CGFloat SURefreshPullLen      = 60.0;

#define kTopPointColor    [UIColor colorWithRed:90. / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor
#define kLeftPointColor   [UIColor colorWithRed:250 / 255.0 green:85. / 255.0 blue:78. / 255.0 alpha:1.0].CGColor
#define kBottomPointColor [UIColor colorWithRed:92. / 255.0 green:201 / 255.0 blue:105 / 255.0 alpha:1.0].CGColor
#define kRightPointColor  [UIColor colorWithRed:253 / 255.0 green:175 / 255.0 blue:75. / 255.0 alpha:1.0].CGColor

@interface BossHeaderRefresh ()

@property (nonatomic, weak  ) UIScrollView * scrollView;

@property (nonatomic, strong) CAShapeLayer * lineLayer;

@property (nonatomic, strong) CAShapeLayer * TopPointLayer;
@property (nonatomic, strong) CAShapeLayer * BottomPointLayer;
@property (nonatomic, strong) CAShapeLayer * LeftPointLayer;
@property (nonatomic, strong) CAShapeLayer * rightPointLayer;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL animating;

@end

@implementation BossHeaderRefresh

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, SURefreshHeaderHeight, SURefreshHeaderHeight)]) {
        CGFloat centerLine = SURefreshHeaderHeight / 2;
        CGFloat radius = SURefreshPointRadius;
        
        CGPoint topPoint = CGPointMake(centerLine, radius);
        self.TopPointLayer = [self layerWithPoint:topPoint color:kTopPointColor];
        self.TopPointLayer.hidden = NO;
        self.TopPointLayer.opacity = 0.f;
        [self.layer addSublayer:self.TopPointLayer];
        
        CGPoint leftPoint = CGPointMake(radius, centerLine);
        self.LeftPointLayer = [self layerWithPoint:leftPoint color:kLeftPointColor];
        [self.layer addSublayer:self.LeftPointLayer];
        
        CGPoint bottomPoint = CGPointMake(centerLine, SURefreshHeaderHeight - radius);
        self.BottomPointLayer = [self layerWithPoint:bottomPoint color:kBottomPointColor];
        [self.layer addSublayer:self.BottomPointLayer];
        
        CGPoint rightPoint = CGPointMake(SURefreshHeaderHeight - radius, centerLine);
        self.rightPointLayer = [self layerWithPoint:rightPoint color:kRightPointColor];
        [self.layer addSublayer:self.rightPointLayer];
        
        self.lineLayer = [CAShapeLayer layer];
        self.lineLayer.frame = self.bounds;
        self.lineLayer.lineWidth = SURefreshPointRadius * 2;
        self.lineLayer.lineCap = kCALineCapRound;
        self.lineLayer.lineJoin = kCALineJoinRound;
        self.lineLayer.fillColor = kTopPointColor;
        self.lineLayer.strokeColor = kTopPointColor;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:topPoint];
        [path addLineToPoint:leftPoint];
        [path moveToPoint:leftPoint];
        [path addLineToPoint:bottomPoint];
        [path moveToPoint:bottomPoint];
        [path addLineToPoint:rightPoint];
        [path moveToPoint:rightPoint];
        [path addLineToPoint:topPoint];
        self.lineLayer.path = path.CGPath;
        self.lineLayer.strokeStart = 0.f;
        self.lineLayer.strokeEnd = 0.f;
        [self.layer insertSublayer:self.lineLayer above:self.TopPointLayer];
    }
    return self;
}

- (CAShapeLayer *)layerWithPoint:(CGPoint)center color:(CGColorRef)color {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x - SURefreshPointRadius, center.y - SURefreshPointRadius, SURefreshPointRadius * 2, SURefreshPointRadius * 2);
    layer.fillColor = color;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SURefreshPointRadius, SURefreshPointRadius)
                                                radius:SURefreshPointRadius
                                            startAngle:0
                                              endAngle:M_PI * 2
                                             clockwise:YES].CGPath;
    layer.hidden = YES;
    return layer;
}

#pragma mark - Override

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(self.scrollView.sr_centerX, self.sr_centerY);
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        self.progress = - self.scrollView.contentOffset.y;
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (!self.animating) {
        if (progress >= SURefreshPullLen) {
            self.sr_y = - (SURefreshPullLen - (SURefreshPullLen - SURefreshHeaderHeight) / 2);
        } else {
            if (progress <= self.sr_height) {
                self.sr_y = - progress;
            } else {
                self.sr_y = - (self.sr_height + (progress - self.sr_height) / 2);
            }
        }
        [self setLineLayerStrokeWithProgress:progress];
    }
    
    if (progress >= SURefreshPullLen && !self.animating && !self.scrollView.dragging) {
        [self beginRefreshing];
        if (self.handler) {
            self.handler();
        }
    }
}

- (void)setLineLayerStrokeWithProgress:(CGFloat)progress {
    float startProgress = 0.f;
    float endProgress = 0.f;
    
    if (progress < 0) {
        self.TopPointLayer.opacity = 0.f;
        [self adjustPointStateWithIndex:0];
    } else if (progress >= 0 && progress < (SURefreshPullLen - 40)) {
        self.TopPointLayer.opacity = progress / 20;
        [self adjustPointStateWithIndex:0];
    } else if (progress >= (SURefreshPullLen - 40) && progress < SURefreshPullLen) {
        self.TopPointLayer.opacity = 1.0;
        NSInteger stage = (progress - (SURefreshPullLen - 40)) / 10;
        CGFloat subProgress = (progress - (SURefreshPullLen - 40)) - (stage * 10);
        
        if (subProgress >= 0 && subProgress <= 5) {
            [self adjustPointStateWithIndex:stage * 2];
            startProgress = stage / 4.0;
            endProgress = stage / 4.0 + subProgress / 40.0 * 2;
        }
        
        if (subProgress > 5 && subProgress < 10) {
            [self adjustPointStateWithIndex:stage * 2 + 1];
            startProgress = stage / 4.0 + (subProgress - 5) / 40.0 * 2;
            if (startProgress < (stage + 1) / 4.0 - 0.1) {
                startProgress = (stage + 1) / 4.0 - 0.1;
            }
            endProgress = (stage + 1) / 4.0;
        }
    } else {
        self.TopPointLayer.opacity = 1.0;
        [self adjustPointStateWithIndex:NSIntegerMax];
        startProgress = 1.0;
        endProgress = 1.0;
    }
    self.lineLayer.strokeStart = startProgress;
    self.lineLayer.strokeEnd = endProgress;
}

- (void)adjustPointStateWithIndex:(NSInteger)index {
    self.LeftPointLayer.hidden = index > 1 ? NO : YES;
    self.BottomPointLayer.hidden = index > 3 ? NO : YES;
    self.rightPointLayer.hidden = index > 5 ? NO : YES;
    self.lineLayer.strokeColor = index > 5 ? kRightPointColor : index > 3 ? kBottomPointColor : index > 1 ? kLeftPointColor : kTopPointColor;
}

#pragma mark - Refreshing

- (void)beginRefreshing {
    self.animating = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = SURefreshPullLen;
        self.scrollView.contentInset = inset;
    }];
    
    [self addAnimationToLayer:self.TopPointLayer valueX:0 valueY:SURefreshTranslatLen];
    [self addAnimationToLayer:self.LeftPointLayer valueX:SURefreshTranslatLen valueY:0];
    [self addAnimationToLayer:self.BottomPointLayer valueX:0 valueY:-SURefreshTranslatLen];
    [self addAnimationToLayer:self.rightPointLayer valueX:-SURefreshTranslatLen valueY:0];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.repeatCount = HUGE;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAni"];
}

- (void)addAnimationToLayer:(CALayer *)layer valueX:(CGFloat)valueX valueY:(CGFloat)valueY {
    CAKeyframeAnimation *translationKeyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKeyframeAni.duration = 1.0;
    translationKeyframeAni.repeatCount = HUGE;
    translationKeyframeAni.removedOnCompletion = NO;
    translationKeyframeAni.fillMode = kCAFillModeForwards;
    translationKeyframeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue * fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    NSValue * toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(valueX, valueY, 0)];
    translationKeyframeAni.values = @[fromValue, toValue, fromValue, toValue, fromValue];
    [layer addAnimation:translationKeyframeAni forKey:@"translationKeyframeAni"];
}

- (void)endRefreshing {
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = 0.f;
        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        self.animating = NO;
        [self.TopPointLayer removeAllAnimations];
        [self.LeftPointLayer removeAllAnimations];
        [self.BottomPointLayer removeAllAnimations];
        [self.rightPointLayer removeAllAnimations];
        [self.layer removeAllAnimations];
        [self adjustPointStateWithIndex:0];
    }];
}

@end
