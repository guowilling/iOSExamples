//
//  SetupFundCodeViewController.m
//  SetupFundCodeDemo
//
//  Created by 郭伟林 on 2018/3/7.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SetupFundCodeViewController.h"

static const CGFloat kCodeLabelDistance = 10;

@interface SetupFundCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *codeComponent;

@property (nonatomic, strong) UITextField *codeTF;

@property (nonatomic, strong) NSMutableArray *codeLabels;

@end

@implementation SetupFundCodeViewController

- (NSMutableArray *)codeLabels {
    if (!_codeLabels) {
        _codeLabels = [NSMutableArray array];
    }
    return _codeLabels;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCodeComponent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.codeTF becomeFirstResponder];
}

- (void)setupCodeComponent {
    _codeComponent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    _codeComponent.center = self.view.center;
    [self.view addSubview:_codeComponent];
    
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
    _codeTF = codeTextField;
    
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    CGFloat labelWidth = (codeTextField.frame.size.width - 5 * kCodeLabelDistance) / 6;
    for (int i = 0; i < 6; i++) {
        labelX = i * (labelWidth + kCodeLabelDistance);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelWidth)];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 5;
        [_codeComponent addSubview:label];
        [self.codeLabels addObject:label];
    }
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
