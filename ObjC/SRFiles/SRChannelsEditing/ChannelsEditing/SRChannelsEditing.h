
#import <UIKit/UIKit.h>

@interface SRChannelsEditing : UIScrollView

+ (instancetype)channelViewWithMineChannels:(NSArray *)mineChannles recommendChannels:(NSArray *)recommendChannels;

- (void)show;
- (void)hide;

@end
