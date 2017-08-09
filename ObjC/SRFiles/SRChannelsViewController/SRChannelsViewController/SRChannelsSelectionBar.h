//
//  SRChannelsBar.h
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRChannelsConfiguration;

@protocol SRChannelsBarDelegate <NSObject>

- (void)channelsBarDidSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;

@end

@interface SRChannelsSelectionBar : UIView

@property (nonatomic, weak) id<SRChannelsBarDelegate> delegate;

@property (nonatomic, strong) NSArray<NSString *> *channelTitles;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

- (void)setBarBottomLineHidden:(BOOL)hidden;

- (void)customBar:(void (^)(SRChannelsConfiguration *config))configBlock;

@end
