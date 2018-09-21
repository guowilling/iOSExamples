
#import "SRChannelsEditing.h"
#import "SRHeaderView.h"
#import "SRTitleView.h"
#import "SRChannelItem.h"
#import "SRChannelModel.h"
#import "SRChannelsEditingHeader.h"

static NSUInteger column = 4;
static CGFloat itemSpace = 10;
static CGFloat lineSpace = 10;
static CGFloat itemHeight = 40;

@interface SRChannelsEditing () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *mineChannels;
@property (nonatomic, strong) NSMutableArray *recommendChannels;
@property (nonatomic, strong) NSMutableArray *allChannels;

@property (nonatomic, weak) SRTitleView *titleView1;
@property (nonatomic, weak) SRTitleView *titleView2;

@property (nonatomic, weak) SRChannelModel *dividingModel;

@end

@implementation SRChannelsEditing

- (CGRect)mineChannelsItemFrame:(NSUInteger)index {
    CGFloat itemWidth = (self.frame.size.width - itemSpace * (column + 1)) / column;
    return CGRectMake(itemSpace + (index % column) * (itemWidth + itemSpace),
                      CGRectGetMaxY(self.titleView1.frame) + lineSpace + (index / column) * (itemHeight + lineSpace),
                      itemWidth,
                      itemHeight);
}

- (CGRect)recommendChannelsItemFrame:(NSUInteger)index {
    CGFloat itemWidth = (self.frame.size.width - itemSpace * (column + 1)) / column;
    return CGRectMake(itemSpace + (index % column) * (itemWidth + itemSpace),
                      CGRectGetMaxY(self.dividingModel.frame) + self.titleView1.frame.size.height + lineSpace + (index / column) * (itemHeight + lineSpace),
                      itemWidth,
                      itemHeight);
}

+ (instancetype)channelViewWithMineChannels:(NSArray *)mineChannles recommendChannels:(NSArray *)recommendChannels {
    return [[self alloc] initWithMineChannels:mineChannles recommendChannels:recommendChannels];
}

- (instancetype)initWithMineChannels:(NSArray *)mineChannles recommendChannels:(NSArray *)recommendChannels {
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _mineChannels = mineChannles.mutableCopy;
        _recommendChannels = recommendChannels.mutableCopy;

        [self setupUI];
        [self setupChanels];
    }
    return self;
}

- (void)setupUI {
    SRHeaderView *headerView = [[SRHeaderView alloc] initWithFrame:CGRectMake(0, 0, SR_SCREEN_WIDTH, 40)];
    headerView.closeBtnActionBlock = ^{
        [self hide];
    };
    [self addSubview:headerView];
    
    SRTitleView *titleView1 = [[SRTitleView alloc] initWithTitle:@"我的频道" subTitle:@"点击进入频道" needEditBtn:YES];
    titleView1.frame = CGRectMake(0, headerView.sr_bottom, self.frame.size.width, 54);
    titleView1.editBtnSelectedDidChangeBlock = ^(BOOL isSelected) {
        if (!isSelected) {
            for (SRChannelItem *btn in self.subviews) {
                if (![btn isKindOfClass:[SRChannelItem class]]) continue;
                if (btn.model.isMineChannel) {
                    btn.deleteIcon.hidden = YES;
                } else {
                    btn.deleteIcon.hidden = YES;
                }
            }
        } else {
            for (SRChannelItem *btn in self.subviews) {
                if (![btn isKindOfClass:[SRChannelItem class]]) continue;
                if (btn.model.isMineChannel) {
                    btn.deleteIcon.hidden = NO;
                } else {
                    btn.deleteIcon.hidden = YES;
                }
            }
        }
    };
    [self addSubview:titleView1];
    _titleView1 = titleView1;
    
    SRTitleView *titleView2 = [[SRTitleView alloc] initWithTitle:@"推荐频道" subTitle:@"点击添加频道" needEditBtn:NO];
    titleView2.hidden = YES;
    [self addSubview:titleView2];
    _titleView2 = titleView2;
}

- (void)setupChanels {
    _allChannels = [NSMutableArray array];

    for (int i = 0 ; i < self.mineChannels.count; i++) {
        SRChannelModel *model = [[SRChannelModel alloc] init];
        model.title = self.mineChannels[i];
        model.isMineChannel = YES;
        [self.allChannels addObject:model];
    }
    for (int i = 0 ; i < self.recommendChannels.count; i++) {
        SRChannelModel *model = [[SRChannelModel alloc] init];
        model.title = self.recommendChannels[i];
        model.isMineChannel = NO;
        [self.allChannels addObject:model];
    }
    
    for (int i = 0; i < self.allChannels.count; i++) {
        SRChannelModel *model = self.allChannels[i];
        model.tag = i;
        if (model.isMineChannel) {
            model.frame = [self mineChannelsItemFrame:i];
            self.dividingModel = model;
        }
    }
    for (int i = self.dividingModel.tag + 1; i < self.allChannels.count; i++) {
        SRChannelModel *model = self.allChannels[i];
        if (!model.isMineChannel) {
            int index = i - self.dividingModel.tag - 1;
            model.frame = [self recommendChannelsItemFrame:index];
        }
    }
    
    self.titleView2.sr_top = CGRectGetMaxY(self.dividingModel.frame) + lineSpace;
    self.titleView2.hidden = NO;
    
    for (SRChannelModel *model in self.allChannels) {
        SRChannelItem *channelItem = [[SRChannelItem alloc] initWithMineChannelTouchBlock:^(SRChannelItem *item) {
            if (item.deleteIcon.hidden) {
            } else {
                [self removeChannle:item];
            }
        } recommondChannelTouchBlock:^(SRChannelItem *item) {
            [self addChannel:item];
        }];
        
        [channelItem addLongPressBeginBlock:^(SRChannelItem *item) {
            [self bringSubviewToFront:item];
        } changedBlock:^(SRChannelItem *item, UILongPressGestureRecognizer *longPressGR) {
            [self moveChannleItem:item gestureRecognizer:longPressGR];
        } endedBlock:^(SRChannelItem *item) {
            [self resetChannel:item];
        }];
        
        channelItem.model = model;
        if (channelItem.model.title.length > 2) {
            channelItem.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        [self addSubview:channelItem];
        
        if (model.tag == self.allChannels.count - 1) {
            self.contentSize = CGSizeMake(0, CGRectGetMaxY(model.frame) + 30);
        }
    }
}

- (void)addChannel:(SRChannelItem *)item {
    item.model.isMineChannel = YES;
    
    [self.allChannels removeObject:item.model];
    [self.allChannels insertObject:item.model atIndex:self.dividingModel.tag + 1];
    
    int newDividingIndex = self.dividingModel.tag + 1;

    for (int i = 0 ; i < self.allChannels.count; i++) {
        SRChannelModel *channelModel = self.allChannels[i];
        channelModel.tag = i;
        if (channelModel.isMineChannel) {
            channelModel.frame = [self mineChannelsItemFrame:i];
            channelModel.shouldHideDeleteIcon = self.titleView1.editBtn.selected ? NO : YES;
        } else {
            int index = i - self.dividingModel.tag - 1;
            channelModel.frame = [self recommendChannelsItemFrame:index];
            channelModel.shouldHideDeleteIcon = YES;
        }
        if (i == newDividingIndex) {
            self.dividingModel = channelModel;
        }
    }
    
    [self updateChannels];
}

- (void)removeChannle:(SRChannelItem *)item {
    item.model.isMineChannel = NO;
    
    [self.allChannels removeObject:item.model];
    [self.allChannels insertObject:item.model atIndex:self.dividingModel.tag];
    
    int newDividingIndex = self.dividingModel.tag - 1;
    
    for (int i = 0 ; i < self.allChannels.count; i++) {
        SRChannelModel *channelModel = self.allChannels[i];
        channelModel.tag = i;
        if (channelModel.isMineChannel) {
            channelModel.frame = [self mineChannelsItemFrame:i];
            channelModel.shouldHideDeleteIcon = NO;
        } else {
            int index = i - self.dividingModel.tag - 1;
            channelModel.frame = [self recommendChannelsItemFrame:index];
            channelModel.shouldHideDeleteIcon = YES;
        }
        if (i == newDividingIndex) {
            self.dividingModel = channelModel;
        }
    }
    
    [self updateChannels];
}

- (void)updateChannels {
    for (SRChannelModel *model in self.allChannels) {
        [UIView animateWithDuration:0.25 animations:^{
            model.item.frame = model.frame;
        }];
        model.item.deleteIcon.hidden = model.shouldHideDeleteIcon;
        [model.item reloadData];
    }
}

- (void)setDividingModel:(SRChannelModel *)dividingModel {
    _dividingModel = dividingModel;
    
    if (self.titleView2.hidden) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.titleView2.frame = CGRectMake(0, CGRectGetMaxY(self.dividingModel.frame) + lineSpace, self.frame.size.width, 54);
    }];
}

- (void)moveChannleItem:(SRChannelItem *)item gestureRecognizer:(UILongPressGestureRecognizer *)longPressGR {
    item.center = [longPressGR locationInView:self];
    
    [self destLocationForChannelItem:item completion:^(SRChannelModel *destModel) {
        if (self.dividingModel == item.model) {
            _dividingModel = self.allChannels[item.model.tag - 1];
        } else if (self.dividingModel == destModel) {
            _dividingModel = item.model;
        }
        
        [self.allChannels removeObject:item.model];
        [self.allChannels insertObject:item.model atIndex:destModel.tag];
        for (int i = 0; i < self.allChannels.count; i++) {
            SRChannelModel *model = self.allChannels[i];
            model.tag = i;
            if (model.isMineChannel && model != item.model) {
                model.frame = [self mineChannelsItemFrame:i];
            }
        }

        for (int i = 0 ; i < self.allChannels.count; i++) {
            SRChannelModel *model = self.allChannels[i];
            if (model.isMineChannel && model != item.model) {
                [UIView animateWithDuration:0.25 animations:^{
                    model.item.frame = model.frame;
                }];
            }
        }
    }];
}

- (void)destLocationForChannelItem:(SRChannelItem *)item completion:(void(^)(SRChannelModel *destModel))completion {
    for (SRChannelModel *channelModel in self.allChannels.copy) {
        if (channelModel == item.model) {
            continue;
        }
        if (!channelModel.isMineChannel) {
            continue;
        }
        if (CGRectContainsPoint(channelModel.frame, item.center)) {
            if (completion) {
                completion(channelModel);
            }
        }
    }
}

- (void)resetChannel:(SRChannelItem *)item {
    SRChannelModel *model = item.model;
    model.frame = [self mineChannelsItemFrame:item.model.tag];
    [UIView animateWithDuration:0.25 animations:^{
        item.frame = model.frame;
    }];
}

- (void)show {
    self.sr_y = UIScreen.mainScreen.bounds.size.height;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.sr_y = SR_STATUS_BAR_HEIGHT;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.sr_y = UIScreen.mainScreen.bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
