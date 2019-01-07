//
//  ViewController.m
//  MuticolorCircleViewDemo
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "MuticolorCircleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MuticolorCircleView *muticolorCircleView = [[MuticolorCircleView alloc] initWithFrame:self.view.bounds];
    [muticolorCircleView startAnimation];
    [self.view addSubview:muticolorCircleView];
}

- (void)gradientLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:(id)[UIColor redColor].CGColor];
    [colors addObject:(id)[UIColor blueColor].CGColor];
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [self.view.layer addSublayer:gradientLayer];
}

@end
