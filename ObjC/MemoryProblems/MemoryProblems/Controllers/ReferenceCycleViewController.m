//
//  ReferenceCycleViewController.m
//  MemoryProblems
//
//  Created by SR on 11/11/15.
//  Copyright (c) 2015 SR. All rights reserved.
//

#import "ReferenceCycleViewController.h"
#import "Test.h"

@implementation ReferenceCycleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    Test *test1 = [Test new];
    Test *test2 = [Test new];
    test1.testInstance = test2;
    test2.testInstance = test1;
}

@end
