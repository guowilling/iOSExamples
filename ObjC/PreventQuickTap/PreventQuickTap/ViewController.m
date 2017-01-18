//
//  ViewController.m
//  PreventQuickTap
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Swizzling.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    testBtn.eventInterval = 5.0;
    [testBtn setTitle:@"TEST BUTTTON" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)testBtnAction {
    
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
