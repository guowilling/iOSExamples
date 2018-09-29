
#import "SRChannelModel.h"

@implementation SRChannelModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldHideDeleteIcon = YES;
    }
    return self;
}

@end
