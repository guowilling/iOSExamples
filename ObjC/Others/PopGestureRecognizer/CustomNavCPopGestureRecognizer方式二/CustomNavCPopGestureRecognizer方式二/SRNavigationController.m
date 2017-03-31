//
//  SRNavigationController.m
//  CustomNavCPopGestureRecognizer方式一
//
//  Created by 郭伟林 on 16/5/16.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRNavigationController.h"
#import <objc/runtime.h>

@interface SRNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation SRNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    //NSLog(@"%@", gesture);
    gesture.enabled = NO;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [gesture.view addGestureRecognizer:panGestureRecognizer];
    
//    unsigned int varCount = 0;
//    Ivar *varList = class_copyIvarList([UIGestureRecognizer class], &varCount);
//    for (int i = 0; i < varCount; i++) {
//        Ivar var = *(varList + i);
//        NSLog(@"%s", ivar_getTypeEncoding(var));
//        NSLog(@"%s", ivar_getName(var));
//    }
    NSMutableArray *targets = [gesture valueForKey:@"targets"];
    //NSLog(@"%@", targets);
    id gestureRecognizerTarget = [targets firstObject];
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"target"];
    SEL handleNavigationTransition = NSSelectorFromString(@"handleNavigationTransition:");
    [panGestureRecognizer addTarget:navigationInteractiveTransition action:handleNavigationTransition];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 以下两个情况不允许手势执行:
    // 1、当前控制器为根控制器
    // 2、如果这个push或pop动画正在执行(私有属性)
    if (self.viewControllers.count == 1 || [[self valueForKey:@"isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}

@end
