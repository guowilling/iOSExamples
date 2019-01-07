//
//  TestViewControllerB.m
//  BubbleTransitionDemo
//
//  Created by 郭伟林 on 17/4/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "TestViewControllerB.h"
#import "UIViewController+BubbleTransition.h"

@interface TestViewControllerB ()

@end

@implementation TestViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:189/255.0 green:79/255.0 blue:70/255.0 alpha:1];
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    testLabel.textColor = [UIColor whiteColor];
    testLabel.text = @"Bubble Transition";
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:40];
    [self.view addSubview:testLabel];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 50 - 10, 50, 50)];
    //testButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - 50);
    testButton.layer.cornerRadius = 25.0;
    [testButton setBackgroundColor:[UIColor whiteColor]];
    [testButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    // present 和 dismiss 转场在 B 中设置.
    self.bubblePresentTranstion = [BubbleTransition transitionWithAnchorRect:testButton.frame];
    self.bubbleDismissTranstion = [BubbleTransition transitionWithAnchorRect:testButton.frame];
}

- (void)testButtonAction {
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
