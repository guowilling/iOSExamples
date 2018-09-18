//
//  SRCountDownLabel.m
//  CountDownDemo
//
//  Created by 郭伟林 on 2017/6/30.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRCountDownLabel.h"

#define SRScreenW [UIScreen mainScreen].bounds.size.width
#define SRScreenH [UIScreen mainScreen].bounds.size.height

@interface SRCountDownLabel ()

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) NSString *endTips;

@property (nonatomic, copy) void (^endBlock)();

@end

@implementation SRCountDownLabel

+ (void)startCountDown {
    [self startCountDownWithNumber:3];
}

+ (void)startCountDownWithNumber:(NSInteger)number {
    [self startCountDownWithNumber:number endTips:nil];
}

+ (void)startCountDownWithNumber:(NSInteger)number endTips:(NSString *)tips {
    [self startCountDownWithNumber:number endTips:tips endBlock:nil];
}

+ (void)startCountDownWithNumber:(NSInteger)number endTips:(NSString *)tips endBlock:(void (^)())endBlock {
    SRCountDownLabel *countDownLabel = [[self alloc] initWithNumber:number endTips:tips endBlock:endBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:countDownLabel];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [countDownLabel countDown];
}

- (instancetype)initWithNumber:(NSInteger)number endTips:(NSString *)tips endBlock:(void (^)())endBlock {
    if (self = [super init]) {
        _number = number;
        _endTips = tips;
        _endBlock = endBlock;
        
        self.frame = CGRectMake(0, 0, 200, 200);
        self.transform = CGAffineTransformScale(self.transform, 2, 2);
        self.text = [NSString stringWithFormat:@"%zd", number];
        self.textColor = [UIColor redColor];
        self.font = [UIFont boldSystemFontOfSize:100];
        self.center = CGPointMake(SRScreenW * 0.5, SRScreenH * 0.5);
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)countDown {
    if (self.number > 0) {
        self.text = [NSString stringWithFormat:@"%zd", self.number];
        [UIView animateWithDuration:1 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.transform = CGAffineTransformScale(self.transform, 0.5, 0.5);
            self.alpha = 0.75;
        } completion:^(BOOL finished) {
            if (finished) {
                self.number--;
                self.alpha = 1.0;
                self.transform = CGAffineTransformIdentity;
                self.transform = CGAffineTransformScale(self.transform, 2, 2);
                [self countDown];
            }
        }];
        return;
    }
    
    if (self.endTips) {
        self.text = self.endTips;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
            if (self.endBlock) {
                self.endBlock();
            }
        });
        return;
    }
    
    [self removeFromSuperview];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    if (self.endBlock) {
        self.endBlock();
    }
}

@end
