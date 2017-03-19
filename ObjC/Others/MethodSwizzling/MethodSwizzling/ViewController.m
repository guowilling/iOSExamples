//
//  ViewController.m
//  MethodSwizzling
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    BOOL iOS7 = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
//    if (iOS7) {
//        self.icon1.image = [UIImage imageNamed:@"face_os7"];
//        self.icon2.image = [UIImage imageNamed:@"vip_os7"];
//    } else {
//        self.icon1.image = [UIImage imageNamed:@"face"];
//        self.icon2.image = [UIImage imageNamed:@"vip"];
//    }
    
    self.icon1.image = [UIImage imageNamed:@"face"];
    self.icon2.image = [UIImage imageNamed:@"vip"];
}

@end
