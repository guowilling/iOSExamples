//
//  ViewController.m
//  SetupFundCodeDemo
//
//  Created by 郭伟林 on 2018/3/7.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SetupFundCodeView.h"
#import "SetupFundCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showSetupFundCodeView:(id)sender {
    [self.view addSubview:[SetupFundCodeView setupFundCodeView]];
}

- (IBAction)showSeupFundCodeViewController:(id)sender {
    [self.navigationController pushViewController:[SetupFundCodeViewController new] animated:YES];
}

@end
