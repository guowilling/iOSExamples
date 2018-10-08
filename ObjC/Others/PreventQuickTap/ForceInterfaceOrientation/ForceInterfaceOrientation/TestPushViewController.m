//
//  PushViewController.m
//  ForceInterfaceOrientation
//
//  Created by Willing Guo on 2018/10/6.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "TestPushViewController.h"
#import "AppDelegate.h"
#import "UIDevice+Orientation.h"

@interface TestPushViewController ()

@end

@implementation TestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    [UIDevice switchInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
    [UIDevice switchInterfaceOrientation:UIInterfaceOrientationPortrait];
}

@end
