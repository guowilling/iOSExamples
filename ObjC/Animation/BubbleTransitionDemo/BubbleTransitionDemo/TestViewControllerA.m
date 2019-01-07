//
//  TestViewControllerA.m
//  BubbleTransitionDemo
//
//  Created by 郭伟林 on 17/4/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "TestViewControllerA.h"
#import "TestViewControllerB.h"
#import "UIViewController+BubbleTransition.h"

@interface TestViewControllerA ()

@end

@implementation TestViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 50 - 10, 50, 50)];
    //testButton.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - 50);
    testButton.layer.cornerRadius = 25.0;
    testButton.backgroundColor = [UIColor colorWithRed:189/255.0 green:79/255.0 blue:70/255.0 alpha:1];
    [testButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    // push 和 pop 转场在 A 中设置.
    self.bubblePushTranstion = [BubbleTransition transitionWithAnchorRect:testButton.frame];
    self.bubblePopTranstion = [BubbleTransition transitionWithAnchorRect:testButton.frame];
}

- (void)testButtonAction {
    
    TestViewControllerB *testVCB = [[TestViewControllerB alloc] init];
    if (_pushNextVC) {
        [self.navigationController pushViewController:testVCB animated:true];
    } else {
        [self presentViewController:testVCB animated:true completion:nil];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
