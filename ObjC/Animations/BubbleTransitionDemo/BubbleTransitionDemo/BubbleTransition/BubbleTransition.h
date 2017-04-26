
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BubbleTransitionType) {
    BubbleTransitionTypeShow = 0,
    BubbleTransitionTypeHide
};

@interface BubbleTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BubbleTransitionType transitionType;

+ (instancetype)transitionWithAnchorRect:(CGRect)anchorRect;

@end
