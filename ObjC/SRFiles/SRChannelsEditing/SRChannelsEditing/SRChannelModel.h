
#import <UIKit/UIKit.h>

@class SRChannelItem;

@interface SRChannelModel : NSObject

@property (nonatomic, weak  ) SRChannelItem *item;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) CGRect    frame;
@property (nonatomic, assign) int       tag;
@property (nonatomic, assign) BOOL      isMineChannel;
@property (nonatomic, assign) BOOL      shouldHideDeleteIcon;

@end
