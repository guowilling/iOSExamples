//
//  UIImageView+SRCornerRadius.m
//  ImageCornerRadiusDemo
//
//  Created by 郭伟林 on 2017/7/25.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImageView+SRCornerRadius.h"
#import <objc/runtime.h>

static NSString const *processedImageKey = @"processedImage";

@interface UIImageView ()

@property (assign, nonatomic) BOOL sr_isRounding;
@property (assign, nonatomic) BOOL sr_hadAddObserver;

@property (assign, nonatomic) CGFloat sr_radius;
@property (assign, nonatomic) UIRectCorner sr_corners;

@property (assign, nonatomic) CGFloat  sr_borderWidth;
@property (strong, nonatomic) UIColor *sr_borderColor;

@end

@implementation UIImageView (SRCornerRadius)

#pragma mark - Runtime AssociatedObject

- (BOOL)sr_isRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSr_isRounding:(BOOL)sr_isRounding {
    objc_setAssociatedObject(self, @selector(sr_isRounding), @(sr_isRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sr_hadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSr_hadAddObserver:(BOOL)sr_hadAddObserver {
    objc_setAssociatedObject(self, @selector(sr_hadAddObserver), @(sr_hadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sr_radius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSr_radius:(CGFloat)sr_radius {
    objc_setAssociatedObject(self, @selector(sr_radius), @(sr_radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)sr_corners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setSr_corners:(UIRectCorner)sr_corners {
    objc_setAssociatedObject(self, @selector(sr_corners), @(sr_corners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sr_borderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSr_borderWidth:(CGFloat)sr_borderWidth {
    objc_setAssociatedObject(self, @selector(sr_borderWidth), @(sr_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)sr_borderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSr_borderColor:(UIColor *)sr_borderColor {
    objc_setAssociatedObject(self, @selector(sr_borderColor), sr_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Runtime Swizzle

+ (void)swizzleOriginalMethod:(SEL)originalSEL destMethod:(SEL)destSEL {
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    Method destMethod = class_getInstanceMethod(self, destSEL);
    method_exchangeImplementations(originalMethod, destMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleOriginalMethod:NSSelectorFromString(@"dealloc") destMethod:@selector(sr_dealloc)];
    });
}

- (void)sr_dealloc {
    if (self.sr_hadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self sr_dealloc];
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleOriginalMethod:@selector(layoutSubviews) destMethod:@selector(sr_layoutSubviews)];
    });
}

- (void)sr_layoutSubviews {
    [self sr_layoutSubviews];
    
    if (self.sr_isRounding) {
        [self sr_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width * 0.5 rectCornerType:UIRectCornerAllCorners];
        return;
    }
    if (self.image && self.sr_radius && self.sr_corners) {
        [self sr_cornerRadiusWithImage:self.image cornerRadius:self.sr_radius rectCornerType:self.sr_corners];
    }
}

#pragma mark - Init Methods

+ (instancetype)sr_advanceImageViewWithCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    UIImageView *imageView = [[self alloc] init];
    [imageView sr_advanceCornerRadius:radius corners:corners];
    return imageView;
}

+ (instancetype)sr_advanceRoundingRectImageView {
    UIImageView *imageView = [[self alloc] init];
    [imageView sr_advanceRoundingRect];
    return imageView;
}

- (void)sr_advanceCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    self.sr_radius = radius;
    self.sr_corners = corners;
    self.sr_isRounding = NO;
    if (!self.sr_hadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.sr_hadAddObserver = YES;
    }
    [self layoutIfNeeded];
}

- (void)sr_advanceRoundingRect {
    self.sr_isRounding = YES;
    if (!self.sr_hadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.sr_hadAddObserver = YES;
    }
    [self layoutIfNeeded];
}

- (void)sr_attachBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    self.sr_borderWidth = width;
    self.sr_borderColor = color;
}

#pragma mark - Core Methods

/**
 Clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered.
 */
- (void)sr_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (!currentContext) {
        return;
    }
    CGSize cornerRadiusSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadiusSize];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &processedImageKey, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 Clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers.
 */
- (void)sr_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (!currentContext) {
        return;
    }
    CGSize cornerRadiusSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadiusSize];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &processedImageKey, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

- (void)drawBorder:(UIBezierPath *)path {
    if (self.sr_borderWidth && self.sr_borderColor) {
        [path setLineWidth:2 * self.sr_borderWidth];
        [self.sr_borderColor setStroke];
        [path stroke];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &processedImageKey) intValue] == 1) {
            return;
        }
        
        if (self.frame.size.width == 0) {
            [self.class swizzleLayoutSubviews];
        }
        
        if (self.sr_isRounding) {
            [self sr_cornerRadiusWithImage:newImage
                              cornerRadius:self.frame.size.width * 0.5
                            rectCornerType:UIRectCornerAllCorners];
            return;
        }
        if (self.image && self.sr_radius && self.sr_corners) {
            [self sr_cornerRadiusWithImage:newImage
                              cornerRadius:self.sr_radius
                            rectCornerType:self.sr_corners];
        }
    }
}

@end
