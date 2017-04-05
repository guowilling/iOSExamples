//
//  ViewController.m
//  ShimmeringLabel
//
//  Created by Willing Guo on 2017/4/5.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "ViewController.h"
#import "ShimmeringLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGSize textSize = [@"Shimmering Label" boundingRectWithSize:CGSizeMake(300, 35)
                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30]}
                                                        context:nil].size;
    
    ShimmeringLabel *shimmeringLabel1 = [[ShimmeringLabel alloc] init];
    shimmeringLabel1.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    shimmeringLabel1.center = self.view.center;
    shimmeringLabel1.center = CGPointMake(shimmeringLabel1.center.x, shimmeringLabel1.center.y - 100);
    shimmeringLabel1.text = @"Shimmering Label";
    shimmeringLabel1.textColor = [UIColor grayColor];
    shimmeringLabel1.font = [UIFont systemFontOfSize:30];
    [shimmeringLabel1 startShimmering];
    [self.view addSubview:shimmeringLabel1];
    
    ShimmeringLabel *shimmeringLabel2 = [[ShimmeringLabel alloc] init];
    shimmeringLabel2.bounds = shimmeringLabel1.bounds;
    shimmeringLabel2.center = CGPointMake(shimmeringLabel1.center.x, shimmeringLabel1.center.y + 100);
    shimmeringLabel2.text = @"Shimmering Label";
    shimmeringLabel2.textColor = [UIColor grayColor];
    shimmeringLabel2.font = [UIFont systemFontOfSize:30];
    shimmeringLabel2.shimmeringType = ShimmeringRightToLeft;
    shimmeringLabel2.shimmeringDuration = 1.0;
    shimmeringLabel2.shimmeringColor = [UIColor orangeColor];
    [shimmeringLabel2 startShimmering];
    [self.view addSubview:shimmeringLabel2];
    
    ShimmeringLabel *shimmeringLabel3 = [[ShimmeringLabel alloc] init];
    shimmeringLabel3.bounds = shimmeringLabel1.bounds;
    shimmeringLabel3.center = CGPointMake(shimmeringLabel2.center.x, shimmeringLabel2.center.y + 100);
    shimmeringLabel3.text = @"Shimmering Label";
    shimmeringLabel3.textColor = [UIColor grayColor];
    shimmeringLabel3.font = [UIFont systemFontOfSize:30];
    shimmeringLabel3.shimmeringType = ShimmeringAutoReverse;
    shimmeringLabel3.shimmeringWidth = 25;
    shimmeringLabel3.shimmeringRadius = 25;
    shimmeringLabel3.shimmeringColor = [UIColor yellowColor];
    [shimmeringLabel3 startShimmering];
    [self.view addSubview:shimmeringLabel3];
    
    ShimmeringLabel *shimmeringLabel4 = [[ShimmeringLabel alloc] init];
    shimmeringLabel4.bounds = shimmeringLabel1.bounds;
    shimmeringLabel4.center = CGPointMake(shimmeringLabel3.center.x, shimmeringLabel3.center.y + 100);
    shimmeringLabel4.text = @"Shimmering Label";
    shimmeringLabel4.textColor = [UIColor grayColor];
    shimmeringLabel4.font = [UIFont systemFontOfSize:30];
    shimmeringLabel4.shimmeringType = ShimmeringFull;
    shimmeringLabel4.shimmeringDuration = 1.0;
    shimmeringLabel4.shimmeringColor = [UIColor redColor];
    [shimmeringLabel4 startShimmering];
    [self.view addSubview:shimmeringLabel4];
}

@end
