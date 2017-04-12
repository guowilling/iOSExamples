//
//  ViewController.m
//  LoadingIndicatorDemo
//
//  Created by 郭伟林 on 17/4/12.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "LoadingIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *iamgeView =[[UIImageView alloc] initWithFrame:self.view.bounds];
    iamgeView.image =[UIImage imageNamed:@"newfeature.jpg"];
    [self.view addSubview:iamgeView];
    
    LoadingIndicatorView *loadingIndicator = [[LoadingIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingIndicator.center = self.view.center;
    [self.view addSubview:loadingIndicator];
    [loadingIndicator show];
}

@end
