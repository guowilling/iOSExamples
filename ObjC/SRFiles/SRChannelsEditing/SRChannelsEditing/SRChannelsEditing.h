//
//  Created by https://github.com/guowilling on 2017/8/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRChannelsEditing : UIScrollView

+ (instancetype)channelViewWithMineChannels:(NSArray *)mineChannles recommendChannels:(NSArray *)recommendChannels;

- (void)show;
- (void)hide;

@end
