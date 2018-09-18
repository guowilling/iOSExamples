//
//  SRCustomSwitch.m
//  CustomUISwitch
//
//  Created by 郭伟林 on 2017/6/28.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRCustomSwitch.h"

#define SRScreenW [UIScreen mainScreen].bounds.size.width
#define SRScreenH [UIScreen mainScreen].bounds.size.height

@interface SRCustomSwitch ()

@property (nonatomic, strong) UIView *dotView;

@property (nonatomic, strong) UIView *barView;

@end

@implementation SRCustomSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupWithFrame:self.frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    _barView = [[UIView alloc] initWithFrame:CGRectMake(x, (h - h * 0.5) * 0.5, w, h * 0.5)];
    _barView.layer.cornerRadius = h * 0.5 * 0.5;
    [self addSubview:_barView];
    
    _dotView = [[UIView alloc] initWithFrame:CGRectMake(x, y, h, h)];
    _dotView.layer.cornerRadius = h * 0.5;
    [self addSubview:_dotView];
    
    self.onDotColor = self.offDotColor = [UIColor whiteColor];
    self.onBarColor = [UIColor blackColor];
    self.offBarColor = [UIColor whiteColor];
    self.tintColor = [UIColor lightGrayColor];
    
    _on = NO;
    [self setSwitchColorWithStatus:_on];
}

- (void)switchStatus:(BOOL)isOn animated:(BOOL)flag {
    _on = isOn;
    CGFloat newX = isOn ? self.frame.size.width - self.dotView.frame.size.width : 0;
    [UIView animateWithDuration:flag ? 0.25 : 0 animations:^{
        CGRect frame = self.dotView.frame;
        frame.origin.x = newX;
        self.dotView.frame = frame;
        [self setSwitchColorWithStatus:_on];
    } completion:^(BOOL finished) {
        if (self.statusChanged) {
            self.statusChanged(self.isOn);
        }
    }];
}

- (void)setSwitchColorWithStatus:(BOOL)on {
    self.barView.backgroundColor = on ? _onBarColor : _offBarColor;
    self.dotView.backgroundColor = on ? _onDotColor : _offDotColor;
}

- (void)setOnDotColor:(UIColor *)onDotColor {
    _onDotColor = onDotColor;
    
    [self setSwitchColorWithStatus:_on];
}

- (void)setOnBarColor:(UIColor *)onBarColor {
    _onBarColor = onBarColor;
    
    [self setSwitchColorWithStatus:_on];
}

- (void)setOffDotColor:(UIColor *)offDotColor {
    _offDotColor = offDotColor;
    
    [self setSwitchColorWithStatus:_on];
}

- (void)setOffBarColor:(UIColor *)offBarColor {
    _offBarColor = offBarColor;
    
    [self setSwitchColorWithStatus:_on];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    self.dotView.layer.borderColor = self.barView.layer.borderColor = tintColor.CGColor;
    self.dotView.layer.borderWidth = self.barView.layer.borderWidth = 0.5;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self switchStatus:!_on animated:YES];
}

@end
