//
//  ViewController.m
//  CustomUISwitch
//
//  Created by 郭伟林 on 2017/6/28.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRCustomSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SRCustomSwitch *customSwitch = [[SRCustomSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    customSwitch.center = self.view.center;
    customSwitch.statusChanged = ^(BOOL isOn) {
        if (isOn) {
            NSLog(@"开");
        } else {
            NSLog(@"关");
        }
    };
    [self.view addSubview:customSwitch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
