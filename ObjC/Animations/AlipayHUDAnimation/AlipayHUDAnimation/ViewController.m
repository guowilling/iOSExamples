//
//  ViewController.m
//  AlipayHUDAnimation
//
//  Created by Willing Guo on 2017/4/16.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "ViewController.h"
#import "PayLoadingHUD.h"
#import "PaySuccessHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始支付" style:UIBarButtonItemStylePlain target:self action:@selector(showLoadingAnimation)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"支付完成" style:UIBarButtonItemStylePlain target:self action:@selector(showSuccessAnimation)];
}

- (void)showLoadingAnimation {
    
    self.title = @"正在付款...";
    
    [PaySuccessHUD hideIn:self.view];
    [PayLoadingHUD showIn:self.view];
}

- (void)showSuccessAnimation {
    
    self.title = @"付款完成";
    
    [PayLoadingHUD hideIn:self.view];
    [PaySuccessHUD showIn:self.view];
}

@end
