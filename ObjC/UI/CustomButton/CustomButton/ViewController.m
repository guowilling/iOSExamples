//
//  ViewController.m
//  CustomButton
//
//  Created by 郭伟林 on 16/12/28.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRCustomButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGFloat margin = 20;
    CGFloat buttonWidth = (CGRectGetWidth(self.view.frame) - 20 * 3) / 2.0;
    CGFloat buttonHeight = buttonWidth;
    
    SRCustomButton *customBtn1 = [self custombuttonWithStyle:LayoutStyleLeftImageRightTitle];
    customBtn1.frame = CGRectMake(margin, 64 + margin, buttonWidth, buttonHeight);
    [self.view addSubview:customBtn1];
    
    SRCustomButton *customBtn2 = [self custombuttonWithStyle:LayoutStyleLeftTitleRightImage];
    customBtn2.frame = CGRectMake(margin + buttonWidth + margin, 64 + margin, buttonWidth, buttonHeight);
    [self.view addSubview:customBtn2];
    
    SRCustomButton *customBtn3 = [self custombuttonWithStyle:LayoutStyleUpImageDownTitle];
    customBtn3.frame = CGRectMake(margin, 64 + margin + buttonHeight + margin, buttonWidth, buttonHeight);
    [self.view addSubview:customBtn3];
    
    SRCustomButton *customBtn4 = [self custombuttonWithStyle:LayoutStyleUpTitleDownImage];
    customBtn4.frame = CGRectMake(margin + buttonWidth + margin, 64 + margin + buttonHeight + margin, buttonWidth, buttonHeight);
    [self.view addSubview:customBtn4];
    
    SRCustomButton *customSizeButton = [self custombuttonWithStyle:LayoutStyleUpImageDownTitle];
    customSizeButton.imageSize = CGSizeMake(40, 20);
    [customSizeButton setTitle:@"CustomSize" forState:UIControlStateNormal];
    customSizeButton.frame = CGRectMake((CGRectGetWidth(self.view.frame) - buttonWidth) / 2.0, 64 + margin * 3 + buttonHeight * 2, buttonWidth, buttonHeight);
    [self.view addSubview:customSizeButton];
}

- (SRCustomButton *)custombuttonWithStyle:(ButtonLayoutStyle)style {
    
    SRCustomButton *button = [SRCustomButton buttonWithType:UIButtonTypeCustom];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layoutStyle = style;
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button setTitle:@"Naruto" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Naruto"] forState:UIControlStateNormal];
    return button;
}

@end
