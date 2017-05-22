//
//  ViewController.m
//  CommonWebViewDemo
//
//  Created by 郭伟林 on 17/5/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "CommonWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loadBaiduWebsite {
    
    CommonWebViewController *commonWebVC = [[CommonWebViewController alloc]init];
    commonWebVC.URLString = @"https://www.baidu.com";
    commonWebVC.canPullDownToRefresh = YES;
    [self.navigationController pushViewController:commonWebVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
