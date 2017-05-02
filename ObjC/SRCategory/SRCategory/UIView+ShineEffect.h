//
//  UIView+ShineEffect.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShineEffect)

/**
 动画的间隔
 */
@property (nonatomic, strong) NSNumber *shineInterval;

/**
 动画的周期
 */
@property (nonatomic, strong) NSNumber *shineDuration;

/**
 动画透明度: 0 ~ 1.
 */
@property (nonatomic, strong) NSNumber *shineLayerOpacity;

- (void)createShineLayerWithColor:(UIColor *)color radius:(CGFloat)radius;

- (void)shineLayerInfiniteLoop;
- (void)shineLayerHiddenToShow;
- (void)shineLayerShowToHidden;

@end
