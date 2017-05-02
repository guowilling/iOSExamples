//
//  UIView+ShineEffect.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIView+ShineEffect.h"
#import <objc/runtime.h>

#define SHINELAYER_FLAG @"UIView+ShineEffect"

@interface UIView ()

@property (strong, nonatomic) dispatch_source_t dispatchSource;
@property (strong, nonatomic) NSNumber         *shineLayerShow;

@end

@implementation UIView (ShineEffect)

#pragma mark - Private Property

static char dispatchSourceFlag;

- (dispatch_source_t)dispatchSource {
    
    return objc_getAssociatedObject(self, &dispatchSourceFlag);
}

- (void)setDispatchSource:(dispatch_source_t)dispatchSource {
    
    objc_setAssociatedObject(self, &dispatchSourceFlag, dispatchSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char glowViewShowFlag;

- (NSNumber *)shineLayerShow {
    
    return objc_getAssociatedObject(self, &glowViewShowFlag);
}

- (void)setShineLayerShow:(NSNumber *)shineLayerShow {
    
    objc_setAssociatedObject(self, &glowViewShowFlag, shineLayerShow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Property

static char shineIntervalFlag;

- (void)setShineInterval:(NSNumber *)shineInterval {
    
    objc_setAssociatedObject(self, &shineIntervalFlag, shineInterval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)shineInterval {
    
    return objc_getAssociatedObject(self, &shineIntervalFlag);
}

static char shineLayerOpacityFlag;

- (void)setShineLayerOpacity:(NSNumber *)shineLayerOpacity {
    
    objc_setAssociatedObject(self, &shineLayerOpacityFlag, shineLayerOpacity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)shineLayerOpacity {
    
    return objc_getAssociatedObject(self, &shineLayerOpacityFlag);
}

static char shineDurationFlag;

- (void)setShineDuration:(NSNumber *)glowDuration {
    
    objc_setAssociatedObject(self, &shineDurationFlag, glowDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)shineDuration {
    
    return objc_getAssociatedObject(self, &shineDurationFlag);
}

#pragma mark - Public Methods

- (void)createShineLayerWithColor:(UIColor *)color radius:(CGFloat)radius {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:(CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.bounds.size.height)}];
    [color setFill];
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1.0];
    CALayer *shineLayer      = [CALayer layer];
    shineLayer.name          = SHINELAYER_FLAG;
    shineLayer.frame         = self.bounds;
    shineLayer.contents      = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    shineLayer.shadowOpacity = 1.0f;
    shineLayer.shadowOffset  = CGSizeMake(0, 0);
    shineLayer.shadowColor   = (color == nil ? [UIColor redColor].CGColor : color.CGColor);
    shineLayer.shadowRadius  = (radius > 0 ? radius : 2.f);
    shineLayer.opacity       = 0.f;
    [self.layer addSublayer:shineLayer];
    UIGraphicsEndImageContext();
}

- (void)shineLayerInfiniteLoop {
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *layer = obj;
        if ([layer.name isEqualToString:SHINELAYER_FLAG]) {
            if (self.shineLayerShow == nil) {
                self.shineLayerShow = [NSNumber numberWithBool:NO];
            }
            
            if (self.dispatchSource == nil) {
                self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(self.dispatchSource,
                                          dispatch_time(DISPATCH_TIME_NOW, 0),
                                          NSEC_PER_SEC * (self.shineInterval == nil ? 1 : self.shineInterval.floatValue),
                                          0);
                dispatch_source_set_event_handler(self.dispatchSource, ^{
                    if (self.shineLayerShow.boolValue == NO) {
                        self.shineLayerShow = [NSNumber numberWithBool:YES];
                        
                        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                        if (self.shineLayerOpacity != nil) {
                            animation.fromValue = @(0.f);
                            animation.toValue   = self.shineLayerOpacity;
                            layer.opacity       = self.shineLayerOpacity.floatValue;
                        } else {
                            animation.fromValue = @(0.f);
                            animation.toValue   = @(0.8f);
                            layer.opacity       = 0.8;
                        }
                        
                        if (self.shineDuration != nil) {
                            animation.duration = self.shineDuration.floatValue;
                        } else {
                            animation.duration = 0.8;
                        }
                        [layer addAnimation:animation forKey:nil];
                        
                    } else {
                        self.shineLayerShow = [NSNumber numberWithBool:NO];
                        
                        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                        animation.fromValue         = [NSNumber numberWithFloat:layer.opacity];
                        animation.toValue           = @(0.f);
                        if (self.shineDuration != nil) {
                            animation.duration = self.shineDuration.floatValue;
                            layer.opacity      = 0.f;
                        } else {
                            animation.duration = 0.8;
                            layer.opacity      = 0.f;
                        }
                        [layer addAnimation:animation forKey:nil];
                    }
                });
                dispatch_resume(self.dispatchSource);
            }
        }
    }];
}

- (void)shineLayerHiddenToShow {
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *layer = obj;
        if ([layer.name isEqualToString:SHINELAYER_FLAG]) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            if (self.shineLayerOpacity != nil) {
                animation.fromValue = @(0);
                animation.toValue   = self.shineLayerOpacity;
                layer.opacity       = self.shineLayerOpacity.floatValue;
            } else {
                animation.fromValue = @(0);
                animation.toValue   = @(0.8);
                layer.opacity       = 0.8;
            }
            
            if (self.shineDuration != nil) {
                animation.duration = self.shineDuration.floatValue;
            } else {
                animation.duration = 0.8;
            }
            [layer addAnimation:animation forKey:nil];
        }
    }];
}

- (void)shineLayerShowToHidden {
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *layer = obj;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue         = [NSNumber numberWithFloat:layer.opacity];
        animation.toValue           = @(0.f);
        if (self.shineDuration != nil) {
            animation.duration = self.shineDuration.floatValue;
            layer.opacity      = 0.f;
        } else {
            animation.duration = 0.8;
            layer.opacity      = 0.f;
        }
        [layer addAnimation:animation forKey:nil];
    }];
}

@end
