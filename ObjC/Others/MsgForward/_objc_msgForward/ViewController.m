//
//  ViewController.m
//  _objc_msgForward
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *person = [[Person alloc] init];
    [person run];
}

@end
