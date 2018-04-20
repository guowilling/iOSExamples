//
//  ViewController.m
//  StrongweakDance
//
//  Created by Willing Guo on 2017/3/14.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, copy) void (^callBack)();

@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    self.callBack = ^{
        __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"%@", strongSelf.view);
        [NSThread sleepForTimeInterval:5];
        NSLog(@"%@", strongSelf.view);
        
//        NSLog(@"%@", weakSelf.view);
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@"%@", weakSelf.view); // here will print (null)
    };
    dispatch_async(dispatch_get_global_queue(0, 0), self.callBack);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
