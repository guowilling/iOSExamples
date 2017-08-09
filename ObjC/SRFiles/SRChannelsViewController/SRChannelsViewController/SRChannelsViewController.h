//
//  SRChannelsViewController.h
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRChannelsConfiguration.h"

@interface SRChannelsViewController : UIViewController

@property (nonatomic, assign) CGFloat barOffsetY;

@property (nonatomic, assign) BOOL barBottomLineHidden;

- (void)setupWithChannelTitles:(NSArray<NSString *> *)channelTitles childVCs:(NSArray <UIViewController *>*)childVCs;

- (void)customChannelsSelectionBar:(void (^)(SRChannelsConfiguration *config))configBlock;

@end
