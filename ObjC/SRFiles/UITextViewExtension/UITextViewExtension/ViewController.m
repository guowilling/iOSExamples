//
//  ViewController.m
//  UITextViewExtension
//
//  Created by 郭伟林 on 2017/6/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+SRExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextView *textView = [[UITextView alloc] init];
    [self.view addSubview:textView];
    textView.frame = CGRectMake(10, 200, self.view.frame.size.width - 20, 0);
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.placeholder = @"I am placeholder...";
    textView.placeholderColor = [UIColor grayColor];
    textView.minHeight = 100;
    textView.maxHeight = 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
