//
//  SRSafeTimer.m
//  SRSafeTimerDemo
//
//  Created by 郭伟林 on 2018/2/9.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRSafeTimer.h"

@interface SRSafeTimer ()

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation SRSafeTimer

- (void)dealloc {
    [self invalidate];
}

+ (instancetype)sr_safeTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                      repeat:(BOOL)isRepeat
                                     handler:(repeatHandlerBlock)handler
{
    return [self sr_safeTimerWithTimeInterval:timeInterval repeat:isRepeat queue:dispatch_get_main_queue() handler:handler];
}

+ (instancetype)sr_safeTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                      repeat:(BOOL)isRepeat
                                       queue:(dispatch_queue_t)queue
                                     handler:(repeatHandlerBlock)handler
{
    NSAssert(timeInterval > 0, @"timeInterval must larger than 0!");
    SRSafeTimer *safeTimer = [[SRSafeTimer alloc] init];
    safeTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(safeTimer.timer,
                              dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC),
                              timeInterval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(safeTimer.timer, ^{
        if (handler) {
            handler();
        }
        if (!isRepeat && safeTimer.timer) {
            dispatch_source_cancel(safeTimer.timer);
        }
    });
    return safeTimer;
}

- (void)fire {
    dispatch_resume(self.timer);
}

- (void)frozen {
    dispatch_suspend(self.timer);
}

- (void)invalidate {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
