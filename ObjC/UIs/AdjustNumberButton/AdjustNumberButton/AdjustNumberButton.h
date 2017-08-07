//
//  AdjustNumberButton.h
//  AdjustNumberButton
//
//  Created by 郭伟林 on 2017/7/24.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustNumberButton : UIView

/** 边框颜色, 默认浅灰色 */
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, copy, readonly) NSString *currentNumber;

@property (nonatomic, copy) void (^currentNumberDidChangeBlock)(NSString *currentNumber);

@end
