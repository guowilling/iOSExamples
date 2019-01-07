//
//  ViewController.m
//  BubbleTransitionDemo
//
//  Created by 郭伟林 on 17/4/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "TestViewControllerA.h"
#import "TestViewControllerB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestViewControllerA *testVCA = [[TestViewControllerA alloc] init];
    if (indexPath.row == 0) {
        testVCA.pushNextVC = YES;
    } else {
        testVCA.pushNextVC = NO;
    }
    [self.navigationController pushViewController:testVCA animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
