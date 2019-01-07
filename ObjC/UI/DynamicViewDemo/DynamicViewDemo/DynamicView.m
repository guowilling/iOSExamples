//
//  DynamicView.m
//  DynamicViewDemo
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "DynamicView.h"

@interface DynamicView () <UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) UIView *referenceView;

@end

@implementation DynamicView

- (instancetype)initWithFrame:(CGRect)frame referenceView:(UIView *)view {
    if (self = [super initWithFrame:frame]) {
        self.referenceView = view;
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
        [self.referenceView addSubview:self];
    }
    return self;
}

- (UIDynamicAnimator *)dynamicAnimator {
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
        _dynamicAnimator.delegate = self;
    }
    return _dynamicAnimator;
}

- (void)daynamicBehavior {
    if (self.dynamicAnimator.behaviors) {
        [self.dynamicAnimator removeAllBehaviors];
    }
    
    // 重力行为
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravityBeahvior.magnitude = 6.0;
    [self.dynamicAnimator addBehavior:gravityBeahvior];
    
    // 碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self]];
    [collisionBehavior addBoundaryWithIdentifier:@"collisionBoundary"
                                       fromPoint:CGPointMake(0, self.bounds.size.height + 1)
                                         toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height + 1)];
    [self.dynamicAnimator addBehavior:collisionBehavior];
    
    // 动力行为
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    itemBehaviour.elasticity = 0.55;
    itemBehaviour.friction = 0.3;
    [self.dynamicAnimator addBehavior:itemBehaviour];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"dynamicAnimatorDidPause");
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture {
    if (self.dynamicAnimator.isRunning) { // 防止降落过程中拖动
        return;
    }
    
    CGPoint panGestureTranslation = [panGesture translationInView:self];
    CGFloat offsetY = self.center.y + panGestureTranslation.y;
    NSLog(@"offsetY: %.2f", offsetY);
    if (offsetY > self.frame.size.height * 0.5) {
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(self.center.x, offsetY);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self];
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (offsetY >= 150) {
            [self daynamicBehavior];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                self.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height - 64);
            }];
        }
    }
}

@end
