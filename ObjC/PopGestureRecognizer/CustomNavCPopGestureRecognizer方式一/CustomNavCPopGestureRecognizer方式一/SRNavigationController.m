//
//  SRNavigationController.m
//  CustomNavCPopGestureRecognizer方式一
//
//  Created by 郭伟林 on 16/5/16.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRNavigationController.h"
#import "NavigationInteractiveTransition.h"

@interface SRNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NavigationInteractiveTransition *navigationInteractiveTransition;

@end

@implementation SRNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:panGestureRecognizer];
    
    _navigationInteractiveTransition = [[NavigationInteractiveTransition alloc] initWithNavigationController:self];
    [panGestureRecognizer addTarget:_navigationInteractiveTransition action:@selector(handlePanGuetureRecognizer:)];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 以下两个情况不允许手势执行:
    // 1、当前控制器为根控制器
    // 2、如果这个push或pop动画正在执行(私有属性)
    if (self.viewControllers.count == 1 || [[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}

@end
