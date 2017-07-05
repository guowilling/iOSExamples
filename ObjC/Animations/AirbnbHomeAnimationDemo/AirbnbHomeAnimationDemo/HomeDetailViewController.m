//
//  DetailViewController.m
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "HomeDetailViewController.h"

@interface HomeDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailImageTopConstraint;

@end

@implementation HomeDetailViewController

- (instancetype)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    self.showingAnimationBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf.view layoutIfNeeded];
        strongSelf.detailImageTopConstraint.constant = 0;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            strongSelf.dismissBtn.alpha = 1.0;
            strongSelf.detailImageView.alpha = 1;
            [strongSelf.view layoutIfNeeded];
        } completion:nil];
    };
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dismissBtn.alpha = 0;
    self.detailImageView.alpha = 0;
    self.detailImageTopConstraint.constant = 30;
    [self.view layoutIfNeeded];
    
    self.coverImageView.image = self.coverImage;
}

- (IBAction)dismissBtnAction:(id)sender {
    
    if (self.dismissAniamtionBlock) {
        self.dismissAniamtionBlock(self);
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.alpha = 0;
    } completion:nil];
}

@end
