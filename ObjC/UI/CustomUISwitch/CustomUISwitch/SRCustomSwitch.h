//
//  SRCustomSwitch.h
//  CustomUISwitch
//
//  Created by 郭伟林 on 2017/6/28.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRCustomSwitch : UIView

@property (nonatomic, strong) UIColor *onDotColor;
@property (nonatomic, strong) UIColor *onBarColor;

@property (nonatomic, strong) UIColor *offDotColor;
@property (nonatomic, strong) UIColor *offBarColor;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, readonly, getter=isOn) BOOL on;

@property (nonatomic, copy) void (^statusChanged)(BOOL isOn);

- (void)switchStatus:(BOOL)isOn animated:(BOOL)flag;

@end
