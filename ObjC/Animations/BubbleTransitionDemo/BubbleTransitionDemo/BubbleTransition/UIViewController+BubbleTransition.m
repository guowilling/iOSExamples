
#import "UIViewController+BubbleTransition.h"
#import <objc/runtime.h>

static NSString *bubblePushTransitionKey = @"bubblePushTransition";
static NSString *bubblePopTransitionKey = @"bubblePopTransition";
static NSString *bubblePresentTransitionKey = @"bubblePresentTransition";
static NSString *bubbleDismissTransitionKey = @"bubbleDismissTransition";

@implementation UIViewController (BubbleTransition)

#pragma mark - Associated Object

- (void)setBubblePushTranstion:(BubbleTransition *)bubblePushTranstion {
    
    if (bubblePushTranstion) {
        bubblePushTranstion.transitionType = BubbleTransitionTypeShow;
        self.navigationController.delegate = self;
        objc_setAssociatedObject(self, &bubblePushTransitionKey, bubblePushTranstion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BubbleTransition *)bubblePushTranstion {
    
    return objc_getAssociatedObject(self, &bubblePushTransitionKey);
}

- (void)setBubblePopTranstion:(BubbleTransition *)bubblePopTranstion {
    
    if (bubblePopTranstion) {
        bubblePopTranstion.transitionType = BubbleTransitionTypeHide;
        self.navigationController.delegate = self;
        objc_setAssociatedObject(self, &bubblePopTransitionKey, bubblePopTranstion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BubbleTransition *)bubblePopTranstion {
    
    return objc_getAssociatedObject(self, &bubblePopTransitionKey);
}

- (void)setBubblePresentTranstion:(BubbleTransition *)bubblePresentTranstion {
    
    if (bubblePresentTranstion) {
        bubblePresentTranstion.transitionType = BubbleTransitionTypeShow;
        self.transitioningDelegate = self;
        objc_setAssociatedObject(self, &bubblePresentTransitionKey, bubblePresentTranstion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BubbleTransition *)bubblePresentTranstion {
    
    return objc_getAssociatedObject(self, &bubblePresentTransitionKey);
}

- (void)setBubbleDismissTranstion:(BubbleTransition *)bubbleDismissTranstion {
    
    if (bubbleDismissTranstion) {
        bubbleDismissTranstion.transitionType = BubbleTransitionTypeHide;
        self.transitioningDelegate = self;
        objc_setAssociatedObject(self, &bubbleDismissTransitionKey, bubbleDismissTranstion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BubbleTransition *)bubbleDismissTranstion {
    
    return objc_getAssociatedObject(self, &bubbleDismissTransitionKey);
}

#pragma mark - UINavigationControllerDelegate push 和 pop 转场动画

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush && [fromVC isEqual:self]) {
        return self.bubblePushTranstion;
    } else if (operation == UINavigationControllerOperationPop && [toVC isEqual:self]) {
        return self.bubblePopTranstion;
    } else {
        return nil;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate present 和 dismiss 转场动画

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return (id<UIViewControllerAnimatedTransitioning>)self.bubblePresentTranstion;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return (id<UIViewControllerAnimatedTransitioning>)self.bubbleDismissTranstion;
}

@end
