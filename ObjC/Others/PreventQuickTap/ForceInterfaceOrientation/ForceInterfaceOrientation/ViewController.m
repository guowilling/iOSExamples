//
//  ViewController.m
//  ForceInterfaceOrientation
//
//  Created by Willing Guo on 2018/10/6.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "TestPushViewController.h"
#import "TestModalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushBtnAction:(id)sender {
    [self.navigationController pushViewController:[TestPushViewController new] animated:YES];
}

- (IBAction)modalBtnAction:(id)sender {
    [self presentViewController:[TestModalViewController new] animated:YES completion:nil];
}

@end
