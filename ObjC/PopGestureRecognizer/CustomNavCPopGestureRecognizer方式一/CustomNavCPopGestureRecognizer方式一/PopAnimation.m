//
//  popAnimation.m
//  UIScreenEdgePanGestureRecognizer
//
//  Created by Jazys on 15/3/25.
//  Copyright (c) 2015年 Jazys. All rights reserved.
//

#import "PopAnimation.h"

@interface PopAnimation ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PopAnimation


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.25;
}

// transitionContext可以看作是一个工具用来获取一系列动画执行相关的对象和通知系统动画是否完成等功能
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
  
    [UIView animateWithDuration:duration animations:^{
        // fromVC的视图移动到屏幕最右侧
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        // 动画执行完这个方法必须调用
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
//    _transitionContext = transitionContext;
    {
          //----------------pop动画一---------------//
//        [UIView beginAnimations:@"View Flip" context:nil];
//        [UIView setAnimationDuration:duration];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
//        [UIView commitAnimations];
//        [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    
    {
          //----------------pop动画二---------------//
//        CATransition *cusPopTransition = [CATransition animation];
//        cusPopTransition.type = @"cube";
//        cusPopTransition.subtype = @"fromLeft";
//        cusPopTransition.duration = duration;
//        cusPopTransition.removedOnCompletion = NO;
//        cusPopTransition.fillMode = kCAFillModeForwards;
//        cusPopTransition.delegate = self;
//        [containerView.layer addAnimation:cusPopTransition forKey:nil];
//        [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
}

//- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
//
//    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
//}

@end
