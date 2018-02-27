//
//  SRAnimationNumerEngine.h
//  SRAnimationNumberDemo
//
//  Created by 郭伟林 on 2018/2/26.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(CGFloat endNumber);
typedef void (^RefreshBlock)(CGFloat currentNumber);

typedef NSString *(^TextFormatBlock)(CGFloat currentNumber);
typedef NSAttributedString *(^AttributedTextFormatBlock)(CGFloat currentNumber);

typedef NS_ENUM(NSUInteger, SRAnimationNumerCurve) {
    SRAnimationNumerCurveEaseInOut,
    SRAnimationNumerCurveEaseIn,
    SRAnimationNumerCurveEaseOut,
    SRAnimationNumerCurveLinear
};

@interface SRAnimationNumerEngine : NSObject

+ (instancetype)animationNumerEngine;

- (void)fromNumber:(CGFloat)startNumer
          toNumber:(CGFloat)endNumber
          duration:(CFTimeInterval)duration
             curve:(SRAnimationNumerCurve)curve
           refresh:(RefreshBlock)refresh
        completion:(CompletionBlock)completion;

@end
