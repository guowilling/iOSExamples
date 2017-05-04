//
//  UIView+Animation.h
//  SRCategory
//
//  Created by 郭伟林 on 17/4/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

/** 底部出现 */
- (void)showFromBottom;

/** 底部消失 */
- (void)dismissToBottomWithCompleteBlock:(void(^)())completeBlock;

/** 透明到不透明 */
- (void)emerge;

/** 不透明到透明 */
- (void)fake;

/** 抖动 */
- (void)shakeAnimation;

@end
