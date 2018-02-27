//
//  SRAnimationNumerEngine.m
//  SRAnimationNumberDemo
//
//  Created by 郭伟林 on 2018/2/26.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRAnimationNumerEngine.h"

typedef CGFloat (*AnimationFunctionCurve)(CGFloat);

@interface SRAnimationNumerEngine ()

@property (nonatomic, strong) CADisplayLink *timer;

@property (nonatomic, assign) CGFloat startNumber;
@property (nonatomic, assign) CGFloat endNumber;

@property (nonatomic, assign) CFTimeInterval duration;
/** 记录上一帧动画的时间 */
@property (nonatomic, assign) CFTimeInterval lastTime;
/** 记录动画已持续的时间 */
@property (nonatomic, assign) CFTimeInterval progressTime;

@property (nonatomic, copy) RefreshBlock refresh;
@property (nonatomic, copy) CompletionBlock completion;

@property AnimationFunctionCurve animationFunctionCurve;

@end

@implementation SRAnimationNumerEngine

+ (instancetype)animationNumerEngine {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _animationFunctionCurve = AnimationFunctionCurveEaseInOut;
    }
    return self;
}

- (void)fromNumber:(CGFloat)startNumer
          toNumber:(CGFloat)endNumber
          duration:(CFTimeInterval)duration
             curve:(SRAnimationNumerCurve)curve
           refresh:(RefreshBlock)refresh
        completion:(CompletionBlock)completion
{
    [self cleanTimer];
    
    if (startNumer == endNumber) {
        if (refresh) {
            refresh(endNumber);
        }
        if (completion) {
            completion(endNumber);
        }
        return;
    }
    
    _startNumber = startNumer;
    _endNumber = endNumber;
    _duration = duration;
    _refresh = refresh;
    _completion = completion;
    
    switch (curve) {
        case SRAnimationNumerCurveEaseInOut:
            _animationFunctionCurve = AnimationFunctionCurveEaseInOut;
            break;
        case SRAnimationNumerCurveEaseIn:
            _animationFunctionCurve = AnimationFunctionCurveEaseIn;
            break;
        case SRAnimationNumerCurveEaseOut:
            _animationFunctionCurve = AnimationFunctionCurveEaseOut;
            break;
        case SRAnimationNumerCurveLinear:
            _animationFunctionCurve = AnimationFunctionCurveLinear;
            break;
    }
    
    _lastTime = CACurrentMediaTime();
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshNumber)];
    _timer.frameInterval = 2;
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)refreshNumber {
    CFTimeInterval currentTime = CACurrentMediaTime();
    _progressTime = _progressTime + (currentTime - _lastTime);
    if (_progressTime >= _duration) {
        [self cleanTimer];
        if (_refresh) {
            _refresh(_endNumber);
        }
        if (_completion) {
            _completion(_endNumber);
        }
        return;
    }
    
    if (_refresh) {
        CGFloat percent = _progressTime / _duration;
        CGFloat currentNumber = _startNumber + (_animationFunctionCurve(percent) * (_endNumber - _startNumber));
        _refresh(currentNumber);
    }
    
    _lastTime = currentTime;
}

- (void)cleanTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _progressTime = 0;
}

#pragma mark -

CGFloat AnimationFunctionCurveEaseInOut(CGFloat percent)
{
    if (percent == 0.0 || percent == 1.0) {
        return percent;
    }
    if (percent < 0.5) {
        return 0.5 * pow(2, (20 * percent) - 10);
    } else {
        return -0.5 * pow(2, (-20 * percent) + 10) + 1;
    }
}

CGFloat AnimationFunctionCurveEaseIn(CGFloat percent)
{
    return (percent == 0.0) ? percent : pow(2, 10 * (percent - 1));
}

CGFloat AnimationFunctionCurveEaseOut(CGFloat percent)
{
    return (percent == 1.0) ? percent : 1 - pow(2, -10 * percent);
}

CGFloat AnimationFunctionCurveLinear(CGFloat percent)
{
    return percent;
}

@end
