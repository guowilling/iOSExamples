//
//  ViewController.m
//  UIScrollViewAutolayout
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    [self.view addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor orangeColor];
//    [scrollView addSubview:containerView];
//    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView); // 四周和 scrollView 一致
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000)); // 通过宽高设置 contentSize
//    }];
//    // 之后的控件全部添加到 containerView 上即可.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
