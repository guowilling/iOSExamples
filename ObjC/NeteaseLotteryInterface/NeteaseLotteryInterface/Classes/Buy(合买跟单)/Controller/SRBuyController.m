//
//  SRBuyController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRBuyController.h"
#import "SRTitleButton.h"

@interface SRBuyController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign, getter=isOpen) BOOL open;

@end

@implementation SRBuyController

- (UIView *)contentView {
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor purpleColor];
        _contentView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
        _contentView.hidden = YES;
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)titleBtnClick:(SRTitleButton *)sender {
    
    if (!self.isOpen) {
        self.open = YES;
        [UIView animateWithDuration:1.0 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        self.contentView.hidden = NO;
    } else {
        self.open = NO;
        [UIView animateWithDuration:1.0 animations:^{
            sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, -M_PI);
            //sender.imageView.transform = CGAffineTransformIdentity;
        }];
        self.contentView.hidden = YES;
    }
    
//    [UIView animateWithDuration:0.25 animations:^{
//        if (CGAffineTransformIsIdentity(sender.imageView.transform)) {
//            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
//        } else {
//            sender.imageView.transform = CGAffineTransformIdentity;
//        }
//    }];
}

@end
