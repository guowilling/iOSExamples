//
//  感谢原作者 mengxianliang: https://github.com/mengxianliang/XLBubbleTransition
//

#import <UIKit/UIKit.h>
#import "BubbleTransition.h"

@interface UIViewController (BubbleTransition) <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) BubbleTransition *bubblePushTranstion;
@property (nonatomic, strong) BubbleTransition *bubblePopTranstion;

@property (nonatomic, strong) BubbleTransition *bubblePresentTranstion;
@property (nonatomic, strong) BubbleTransition *bubbleDismissTranstion;

@end
