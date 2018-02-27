//
//  UIButton+SRAnimationNumber.m
//  SRAnimationNumberDemo
//
//  Created by 郭伟林 on 2018/2/26.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "UIButton+SRAnimationNumber.h"

@implementation UIButton (SRAnimationNumber)

#pragma mark - Text

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
                        format:(TextFormatBlock)format
{
    [self sr_animationFromNumber:numberA toNumber:numberB duration:duration curve:curve format:format completion:nil];
}

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
                        format:(TextFormatBlock)format
                    completion:(CompletionBlock)completion
{
    [[SRAnimationNumerEngine animationNumerEngine] fromNumber:numberA toNumber:numberB duration:duration curve:curve refresh:^(CGFloat currentNumber) {
        if (format) {
            [self setTitle:format(currentNumber) forState:UIControlStateNormal];
        } else {
            [self setTitle:[NSString stringWithFormat:@"%.2f", currentNumber] forState:UIControlStateNormal];
        }
    } completion:completion];
}

#pragma mark - Attributed Text

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
              attributedFormat:(AttributedTextFormatBlock)attributedFormat
{
    [self sr_animationFromNumber:numberA toNumber:numberB duration:duration curve:curve attributedFormat:attributedFormat completion:nil];
}

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
              attributedFormat:(AttributedTextFormatBlock)attributedFormat
                    completion:(CompletionBlock)completion
{
    [[SRAnimationNumerEngine animationNumerEngine] fromNumber:numberA toNumber:numberB duration:duration curve:curve refresh:^(CGFloat currentNumber) {
        if (attributedFormat) {
            [self setAttributedTitle:attributedFormat(currentNumber) forState:UIControlStateNormal];
        } else {
            [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", currentNumber]] forState:UIControlStateNormal];
        }
    } completion:completion];
}

@end
