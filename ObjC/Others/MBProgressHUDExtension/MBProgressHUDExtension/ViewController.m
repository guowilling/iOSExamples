//
//  ViewController.m
//  MBProgressHUDExtension
//
//  Created by 郭伟林 on 2018/2/11.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+SR.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    MBProgressHUD *aHUD = [MBProgressHUD sr_showMessage:@"A Message..."];
//    MBProgressHUD *aHUD = [MBProgressHUD sr_showMessage:@"A Message..." onView:self.view];
//    [aHUD hideAnimated:YES afterDelay:2.0];
    
//    [MBProgressHUD sr_showIndeterminateWithMessage:@"A Message..."];
//    [MBProgressHUD sr_showIndeterminateWithMessage:@"A Message..." onView:nil graceTime:2.0];
//    [MBProgressHUD sr_showIndeterminateWithMessage:@"A Message..." onView:nil graceTime:2.0 completionBlock:^{
//        NSLog(@"sr_showIndeterminateWithMessage");
//    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD sr_hideHUD];
//    });
    
//    [MBProgressHUD sr_showIndeterminateWithMessage:@"A Message..."];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD sr_hideHUD];
//        [MBProgressHUD sr_hideHUDForView:nil afterDelay:2.0];
//    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
