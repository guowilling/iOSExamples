//
//  TestViewController.m
//  SRSafeTimerDemo
//
//  Created by 郭伟林 on 2018/2/9.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "TestViewController.h"
#import "SRSafeTimer.h"

@interface TestViewController ()

@property (nonatomic, strong) SRSafeTimer *safeTimer;

@end

@implementation TestViewController

- (void)dealloc {
//    [self.safeTimer invalidate]; // OK
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.safeTimer = [SRSafeTimer sr_safeTimerWithTimeInterval:1.0 repeat:YES handler:^{
        NSLog(@"SRSafeTimer handler...");
    }];
    [self.safeTimer fire];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [self.safeTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
