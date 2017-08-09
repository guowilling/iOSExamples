//
//  ViewController.m
//  SRChannelsViewControllerDemo
//
//  Created by 郭伟林 on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRChannelsViewController.h"
#import "TestViewController.h"
#import "TestTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SRChannelsViewController *channelsViewController = [[SRChannelsViewController alloc] init];
    channelsViewController.barOffsetY = 64;
    channelsViewController.barBottomLineHidden = NO;
    NSArray *channelTitles = @[@"个性推荐", @"歌单", @"主播电台", @"排行榜"];
    UIViewController *vc1 = [TestViewController new];
    UIViewController *vc2 = [TestViewController new];
    UIViewController *vc3 = [TestTableViewController new];
    UIViewController *vc4 = [TestTableViewController new];
    [channelsViewController setupWithChannelTitles:channelTitles childVCs:@[vc1, vc2, vc3, vc4]];
    [self addChildViewController:channelsViewController];
    [self.view addSubview:channelsViewController.view];
    
    [channelsViewController customChannelsSelectionBar:^(SRChannelsConfiguration *config) {
        config.titleNormalColor([UIColor blackColor]).titleSelectedColor([UIColor redColor]).indicatorColor([UIColor redColor]);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
