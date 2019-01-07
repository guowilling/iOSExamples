//
//  ViewController.m
//  CustomUISegmentedControl
//
//  Created by 郭伟林 on 2017/6/29.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRCustomSegmentedControl.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SRCustomSegmentedControl *segmentedControl = [[SRCustomSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 200, 36)
                                                                                          titles:@[@"动态", @"附近"]
                                                                                didTapTitleBlock:^(NSInteger fromIndex, NSInteger toIndex) {
                                                                                    NSLog(@"fromIndex: %zd toIndex: %zd", fromIndex, toIndex);
                                                                                }];
    self.navigationItem.titleView = segmentedControl;
}

@end
