//
//  ViewController.m
//  SRChannelsEditingDemo
//
//  Created by 郭伟林 on 2018/9/21.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRChannelsEditing.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *mineChannels = @[@"推荐", @"热点", @"北京", @"视频",
                              @"社会", @"图片", @"娱乐", @"问答",
                              @"科技", @"汽车", @"财经", @"军事",
                              @"体育", @"段子", @"国际", @"趣图",
                              @"健康", @"特卖", @"房产", @"小说",
                              @"时尚", @"直播", @"育儿", @"搞笑"];
    NSArray *recommendChannels = @[@"历史", @"数码", @"美食", @"养生",
                                   @"电影", @"手机", @"旅游", @"宠物",
                                   @"情感", @"家具", @"教育", @"三农",
                                   @"孕产", @"文化", @"游戏", @"股票",
                                   @"科学", @"动漫", @"故事", @"收藏",
                                   @"精选", @"语录", @"星座", @"美图",
                                   @"小视频", @"微头条", @"正能量", @"中国好表演",
                                   @"明日之子"];
    SRChannelsEditing *channelView = [SRChannelsEditing channelViewWithMineChannels:mineChannels recommendChannels:recommendChannels];
    [channelView show];
}

@end
