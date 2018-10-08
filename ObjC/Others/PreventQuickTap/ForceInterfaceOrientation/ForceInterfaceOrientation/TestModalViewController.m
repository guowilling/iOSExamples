//
//  ModalViewController.m
//  ForceInterfaceOrientation
//
//  Created by Willing Guo on 2018/10/6.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "TestModalViewController.h"
#import "AppDelegate.h"
#import "UIDevice+Orientation.h"

@interface TestModalViewController ()

@property (nonatomic, strong) UIButton *disBtn;

@end

@implementation TestModalViewController

// 横屏情况下系统默认隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    [UIDevice switchInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    
    _disBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_disBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [_disBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_disBtn];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _disBtn.center = self.view.center;
}

- (void)dismiss {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
    [UIDevice switchInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
