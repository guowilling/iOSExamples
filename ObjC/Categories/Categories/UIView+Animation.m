//
//  UIView+Animation.m
//  SRCategory
//
//  Created by 郭伟林 on 17/4/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIView+Animation.h"

#define BottomRect CGRectMake(self.frame.origin.x, [[UIScreen mainScreen] bounds].size.height, self.frame.size.width, self.frame.size.height)

@implementation UIView (Animation)

- (void)showFromBottom {
    CGRect rect = self.frame;
    self.frame = BottomRect;
    [self executeAnimationWithFrame:rect completeBlock:nil];
}

- (void)dismissToBottomWithCompleteBlock:(void(^)())completeBlock {
    [self executeAnimationWithFrame:BottomRect completeBlock:completeBlock];
}

- (void)emerge {
    self.alpha = 0.0;
    [self executeAnimationWithAlpha:0.2 completeBlock:nil];
}

- (void)fake {
    [self executeAnimationWithAlpha:0.f completeBlock:nil];
}

- (void)executeAnimationWithAlpha:(CGFloat)alpha completeBlock:(void(^)())completeBlock {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        if (finished && completeBlock) completeBlock();
    }];
}

- (void)executeAnimationWithFrame:(CGRect)rect completeBlock:(void(^)())completeBlock {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (finished && completeBlock) completeBlock();
    }];
}

- (void)shakeAnimation {
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    ani.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.duration = 0.4;
    [self.layer addAnimation:ani forKey:@"transformAni"];
}

@end
