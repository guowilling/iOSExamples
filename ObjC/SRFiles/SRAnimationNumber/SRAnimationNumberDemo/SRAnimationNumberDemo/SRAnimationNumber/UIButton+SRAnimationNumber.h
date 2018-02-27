//
//  UIButton+SRAnimationNumber.h
//  SRAnimationNumberDemo
//
//  Created by 郭伟林 on 2018/2/26.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRAnimationNumerEngine.h"

@interface UIButton (SRAnimationNumber)

#pragma mark - Text

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
                        format:(TextFormatBlock)format;

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
                        format:(TextFormatBlock)format
                    completion:(CompletionBlock)completion;

#pragma mark - Attributed Text

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
              attributedFormat:(AttributedTextFormatBlock)attributedFormat;

- (void)sr_animationFromNumber:(CGFloat)numberA
                      toNumber:(CGFloat)numberB
                      duration:(CFTimeInterval)duration
                         curve:(SRAnimationNumerCurve)curve
              attributedFormat:(AttributedTextFormatBlock)attributedFormat
                    completion:(CompletionBlock)completion;

@end
