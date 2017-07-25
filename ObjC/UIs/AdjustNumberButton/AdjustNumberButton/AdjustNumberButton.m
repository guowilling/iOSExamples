//
//  AdjustNumberButton.m
//  AdjustNumberButton
//
//  Created by 郭伟林 on 2017/7/24.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "AdjustNumberButton.h"

@interface AdjustNumberButton () {
    
    UIButton *_decreaseBtn;
    UIButton *_increaseBtn;
    
    UIView *_ltVLine;
    UIView *_rtVLine;
    
    UITextField *_textField;
    
    NSTimer *_timer;
}

@end

@implementation AdjustNumberButton

- (void)dealloc {
    
    [self stopTimer];
}

- (void)setTintColor:(UIColor *)tintColor {
    
    _tintColor = tintColor;
    
    _ltVLine.backgroundColor = tintColor;
    _rtVLine.backgroundColor = tintColor;
    self.layer.borderColor = [tintColor CGColor];
}

- (NSString *)currentNumber {
    
    return _textField.text;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    _tintColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    
    self.frame = CGRectMake(0, 0, 110, 30);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [_tintColor CGColor];
    
    _ltVLine = [[UIView alloc] init];
    _ltVLine.backgroundColor = _tintColor;
    [self addSubview:_ltVLine];
    
    _rtVLine = [[UIView alloc] init];
    _rtVLine.backgroundColor = _tintColor;
    [self addSubview:_rtVLine];
    
    _decreaseBtn = [[UIButton alloc] init];
    [self setupButton:_decreaseBtn normalImage:@"decrease@2x" HighlightImage:@"decrease2@2x"];
    [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    [self setupButton:_increaseBtn normalImage:@"increase@2x" HighlightImage:@"increase2@2x"];
    [self addSubview:_increaseBtn];
    
    _textField = [[UITextField alloc] init];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    _textField.text = @"1";
    [self addSubview:_textField];
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage {
    
    [btn setImage:[self imageFromBundle:norImage] forState:UIControlStateNormal];
    [btn setImage:[self imageFromBundle:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside | UIControlEventTouchCancel];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _ltVLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _rtVLine.frame = CGRectMake(viewW - viewH, 0, 1, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

#pragma mark - Assist Methods

- (UIImage *)imageFromBundle:(NSString *)imageName{
    
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"AdjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]];
}

#pragma mark - Button Actions

- (void)btnTouchDown:(UIButton *)btn {
    
    [_textField resignFirstResponder];
    
    if (btn == _increaseBtn) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(increase) userInfo:nil repeats:YES];
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(decrease) userInfo:nil repeats:YES];
    }
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn {
    
    [self stopTimer];
}

#pragma mark - Timer

- (void)increase {
    
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] + 1;
    _textField.text = [NSString stringWithFormat:@"%i", newNum];
    self.currentNumberDidChangeBlock(_textField.text);
}

- (void)decrease {
    
    if (_textField.text.length == 0) {
        _textField.text = @"1";
    }
    int newNum = [_textField.text intValue] -1;
    if (newNum > 0) {
        _textField.text = [NSString stringWithFormat:@"%i", newNum];
        self.currentNumberDidChangeBlock(_textField.text);
    } else {
        NSLog(@"Number can not less than 1");
    }
}

- (void)stopTimer {
    
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
