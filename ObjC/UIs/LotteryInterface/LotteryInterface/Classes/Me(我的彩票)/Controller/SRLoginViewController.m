//
//  SRLoginViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRLoginViewController.h"
#import "SRSettingTableViewController.h"

@interface SRLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation SRLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 拉伸登录按钮图片
    UIImage *normalImage = [UIImage imageNamed:@"RedButton"];
    CGFloat imageW = normalImage.size.width * 0.5;
    CGFloat imageH = normalImage.size.height * 0.5;
    UIImage *newNormalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeStretch];
    [self.loginBtn setBackgroundImage:newNormalImage forState:UIControlStateNormal];
    UIImage *highImage = [UIImage imageNamed:@"RedButtonPressed"];
    CGFloat w = highImage.size.width * 0.5;
    CGFloat h = highImage.size.width * 0.5;
    UIImage *newHighImage = [highImage resizableImageWithCapInsets:UIEdgeInsetsMake(w, h, w, h) resizingMode:UIImageResizingModeStretch];
    [self.loginBtn setBackgroundImage:newHighImage forState:UIControlStateHighlighted];
}

- (IBAction)settingClick:(UIBarButtonItem *)sender {
    
    [self.navigationController pushViewController:[[SRSettingTableViewController alloc] init] animated:YES];
}

@end
