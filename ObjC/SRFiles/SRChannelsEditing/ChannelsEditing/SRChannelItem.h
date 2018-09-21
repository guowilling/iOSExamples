
#import <UIKit/UIKit.h>
#import "SRChannelModel.h"

@interface SRChannelItem : UIButton

@property (nonatomic, strong) SRChannelModel *model;

@property (nonatomic, weak) UIImageView *deleteIcon;

- (instancetype)initWithMineChannelTouchBlock:(void(^)(SRChannelItem *))mineChannelBlock
                   recommondChannelTouchBlock:(void(^)(SRChannelItem *))recommondChannelBlock;

- (void)addLongPressBeginBlock:(void(^)(SRChannelItem *btn))beginBlock
                  changedBlock:(void(^)(SRChannelItem *btn, UILongPressGestureRecognizer *longPressGR))changedBlock
                    endedBlock:(void(^)(SRChannelItem *btn))endedBlock;

- (void)reloadData;

@end
