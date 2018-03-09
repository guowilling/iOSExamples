//
//  SetupFundCodeView.m
//  SetupFundCodeDemo
//
//  Created by 郭伟林 on 2018/3/7.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SetupFundCodeView.h"

static const CGFloat kCodeLabelDistance = 10;

@interface SetupFundCodeView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *codeComponent;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) NSMutableArray *codeLabels;

@end

@implementation SetupFundCodeView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)setupFundCodeView {
    return [[self alloc] init];
}

- (NSMutableArray *)codeLabels {
    if (!_codeLabels) {
        _codeLabels = [NSMutableArray array];
    }
    return _codeLabels;
}

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        [self setupCodeComponent];
        [self.codeTextField becomeFirstResponder];
    }
    return self;
}

- (void)setupCodeComponent {
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [cover addGestureRecognizer:tap];
    [self addSubview:cover];
    
    _codeComponent = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 50)];
    _codeComponent.backgroundColor = [UIColor whiteColor];
    [self addSubview:_codeComponent];
    
    UITextField *codeTextField = [[UITextField alloc] initWithFrame:_codeComponent.bounds];
    codeTextField.backgroundColor = [UIColor clearColor];
    codeTextField.textColor = [UIColor clearColor];
    codeTextField.tintColor = [UIColor clearColor];
    codeTextField.delegate = self;
    codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    [codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_codeComponent addSubview:codeTextField];
    _codeTextField = codeTextField;
    
    CGFloat labelX = 20;
    CGFloat labelWidth = ((codeTextField.frame.size.width - labelX * 2) - 5 * kCodeLabelDistance) / 6;
    CGFloat labelHeight = labelWidth;
    CGFloat labelY = (_codeComponent.frame.size.height - labelHeight) * 0.5;
    for (int i = 0; i < 6; i++) {
        labelX = 20 + i * (labelWidth + kCodeLabelDistance);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 5;
        [_codeComponent addSubview:label];
        [self.codeLabels addObject:label];
    }
}

- (void)dismiss {
    [self.codeTextField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    UILabel *codeLabel;
    if (i == 0) {
        codeLabel = self.codeLabels[0];
        codeLabel.text = @"";
        codeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        codeLabel = self.codeLabels[i - 1];
        codeLabel.text = [NSString stringWithFormat:@"%C", [textField.text characterAtIndex:i - 1]];
        codeLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    if (self.codeLabels.count > i) {
        codeLabel = self.codeLabels[i];
        codeLabel.text = @"";
        codeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    }
    if (i == 6) {
        NSLog(@"6");
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    //UIKeyboardFrameEndUserInfoKey: // 键盘弹出\隐藏后的frame
    //UIKeyboardAnimationDurationUserInfoKey: // 0.25 键盘弹出\隐藏所耗费的时间
    //UIKeyboardAnimationCurveUserInfoKey: // 7 键盘弹出\隐藏动画的执行节奏
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.codeComponent.frame;
        if (keyboardFrame.origin.y == [UIScreen mainScreen].bounds.size.height) { // 键盘隐藏
            frame.origin.y = keyboardFrame.origin.y;
        } else { // 键盘弹出
            frame.origin.y = keyboardFrame.origin.y - self.codeComponent.frame.size.height;
        }
        self.codeComponent.frame = frame;
    }];
}

- (void)keyboardDidHide:(NSNotification*)notification {
    [self removeFromSuperview];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= self.codeLabels.count) {
        return NO;
    } else {
        return YES;
    }
}

@end
