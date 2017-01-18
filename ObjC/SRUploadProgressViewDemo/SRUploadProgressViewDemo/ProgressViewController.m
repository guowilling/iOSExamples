//
//  ProgressViewController.m
//  SRUploadProgressViewDemo
//
//  Created by 郭伟林 on 16/8/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ProgressViewController.h"

@interface ProgressViewController ()

@property (nonatomic, weak) SRUploadProgressView *uploadProgressView;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    SRUploadProgressView *uploadProgressView = [[SRUploadProgressView alloc] init];
    uploadProgressView.frame = self.view.bounds;
    uploadProgressView.type = self.type;
    [self.view addSubview:uploadProgressView];
    _uploadProgressView = uploadProgressView;
    
    //_uploadProgressView.userInteractionEnabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_uploadProgressView.progress <  1.0) {
        _uploadProgressView.progress += 0.2;
    }
}

@end
