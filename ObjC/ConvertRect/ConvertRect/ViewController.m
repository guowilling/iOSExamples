//
//  ViewController.m
//  ConvertRect
//
//  Created by Willing Guo on 17/1/8.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) UIView *blue;
@property (nonatomic, weak) UIView *red;
@property (nonatomic, weak) UIView *yellow;
@property (nonatomic, weak) UIView *purple;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor = [UIColor blueColor];
    blue.frame = CGRectMake(0, 50, 200, 200);
    [self.view addSubview:blue];
    self.blue = blue;
    
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    red.frame = CGRectMake(50, 60, 100, 100);
    [blue addSubview:red];
    self.red = red;
    
    UIView *yellow = [[UIView alloc] init];
    yellow.backgroundColor = [UIColor yellowColor];
    yellow.frame = CGRectMake(10, 10, 50, 50);
    [red addSubview:yellow];
    self.yellow = yellow;
    
    UIView *purple = [[UIView alloc] init];
    purple.backgroundColor = [UIColor purpleColor];
    purple.frame = CGRectMake(50, 350, 100, 100);
    [self.view addSubview:purple];
    self.purple = purple;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    {
        // yellow 在 blue 中的 Rect
        CGRect newRect = [self.yellow convertRect:self.yellow.bounds toView:self.blue];
        NSLog(@"%@", NSStringFromCGRect(newRect));
    }
    
    {
        // yellow 在 purple 中的 Rect
        CGRect newRect = [self.yellow.superview convertRect:self.yellow.frame toView:self.purple];
        NSLog(@"%@", NSStringFromCGRect(newRect));
    }
    
    {
        // red 在 yellow 中的 Rect
        CGRect newRect = [self.red convertRect:self.red.bounds toView:self.yellow];
        NSLog(@"%@", NSStringFromCGRect(newRect));
    }
    
    {
        // red 在屏幕中的 Rect (toView 传 nil 代表 window)
        CGRect newRect = [self.red convertRect:self.red.bounds toView:nil];
        NSLog(@"%@", NSStringFromCGRect(newRect));
    }
}

@end
