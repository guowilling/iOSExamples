//
//  SRCountDownLabel.h
//  CountDownDemo
//
//  Created by 郭伟林 on 2017/6/30.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRCountDownLabel : UILabel

+ (void)startCountDown;
+ (void)startCountDownWithNumber:(NSInteger)number;
+ (void)startCountDownWithNumber:(NSInteger)number endTips:(NSString *)tips;
+ (void)startCountDownWithNumber:(NSInteger)number endTips:(NSString *)tips endBlock:(void (^)())endBlock;

@end
