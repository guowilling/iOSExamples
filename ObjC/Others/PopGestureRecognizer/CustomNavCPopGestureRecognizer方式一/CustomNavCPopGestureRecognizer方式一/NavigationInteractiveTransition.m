//
//  NavigationInteractiveTransition.m
//  UIScreenEdgePanGestureRecognizer
//
//  Created by Jazys on 15/3/30.
//  Copyright (c) 2015年 Jazys. All rights reserved.
//

#import "NavigationInteractiveTransition.h"
#import "PopAnimation.h"

@interface NavigationInteractiveTransition () <UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationController *navC;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end

@implementation NavigationInteractiveTransition

- (instancetype)initWithNavigationController:(UINavigationController *)navC {
    
    self = [super init];
    if (self) {
        _navC = navC;
        _navC.delegate = self;
    }
    return self;
}

- (void)handlePanGuetureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // interactivePopTransition, 我们需要更新它的进度来控制Pop动画的流程, 我们用手指在视图中的位置与视图宽度比例作为它的进度.
    CGFloat progress = [panGestureRecognizer translationInView:panGestureRecognizer.view].x / panGestureRecognizer.view.bounds.size.width;
    // 稳定进度区间让它在 0未完成 ～ 1.0已完成 之间.
    progress = MIN(1.0, MAX(0.0, progress));
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 手势开始新建一个UIPercentDrivenInteractiveTransition对象就是方法2返回的对象
        _percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        // 告诉控制器开始执行pop动画
        [self.navC popViewControllerAnimated:YES];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // 更新手势的完成进度
        [_percentDrivenInteractiveTransition updateInteractiveTransition:progress];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        // 手势结束时如果进度大于一半就完成pop操作否则取消操作
        if (progress > 0.5) {
            [_percentDrivenInteractiveTransition finishInteractiveTransition];
        } else {
            [_percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        _percentDrivenInteractiveTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // 方法1: 如果当前执行的是pop操作就返回我们自定义的pop动画对象
    if (operation == UINavigationControllerOperationPop) {
        return [[PopAnimation alloc] init];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
     // 方法2: 如果animationController是我们自定义的pop动画对象就返回interactivePopTransition来监控动画的完成度
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        return _percentDrivenInteractiveTransition;
    }
    return nil;
}

@end
