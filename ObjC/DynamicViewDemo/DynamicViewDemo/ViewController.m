//
//  ViewController.m
//  DynamicViewDemo
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "DynamicView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) DynamicView *dynamicView;

@property (nonatomic, strong) UIButton *testButton;

@end

@implementation ViewController

- (UIButton *)testButton {
    
    if (!_testButton) {
        _testButton = ({
            UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
            testButton.frame = CGRectMake(0, 0, 80, 40);
            testButton.center = CGPointMake(kScreenW * 0.5, kScreenH * 0.5);
            testButton.backgroundColor = [UIColor redColor];
            [testButton setTitle:@"SHOW" forState:UIControlStateNormal];
            [testButton addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
            testButton;
        });
    }
    return _testButton;
}

- (DynamicView *)dynamicView {
    
    if (!_dynamicView) {
        _dynamicView = [[DynamicView alloc] initWithFrame:CGRectMake(0, -kScreenH + 1, kScreenW + 1, kScreenH + 1)
                                            referenceView:self.view];
        _dynamicView.backgroundColor = [UIColor orangeColor];
        _dynamicView.userInteractionEnabled = YES;
        [self.view addSubview:_dynamicView];
    }
    return _dynamicView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.testButton];
    
    [self.view addSubview:self.dynamicView];
}

- (void)showAction {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.dynamicView.frame = CGRectMake(0, -kScreenH + 1, kScreenW + 1, kScreenH + 1);
    }];
    
    [self.dynamicView daynamicBehavior];
}

@end
