
#import "SRChannelItem.h"
#import "SRChannelsEditingHeader.h"

static UIBezierPath * pathForBtn(SRChannelItem *btn) {
    float width = btn.bounds.size.width;
    float height = btn.bounds.size.height;
    float x = btn.bounds.origin.x;
    float y = btn.bounds.origin.y;
    float addWH = 2;

    CGPoint topLeft   = btn.bounds.origin;
    CGPoint topMiddle = CGPointMake(x + (width/2), y - addWH);
    CGPoint topRight  = CGPointMake(x + width, y);

    CGPoint rightMiddle = CGPointMake(x + width + addWH, y + (height/2));

    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomMiddle = CGPointMake(x + (width/2), y + height + addWH);
    CGPoint bottomLeft   = CGPointMake(x, y + height);

    CGPoint leftMiddle = CGPointMake(x - addWH, y + (height/2));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:topLeft];
    [path addQuadCurveToPoint:topRight controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft controlPoint:leftMiddle];
    return path;
}

static inline void configMineChannelItem(SRChannelItem *btn) {
    btn.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    btn.layer.shadowOffset =  CGSizeMake(0, 0);
    btn.layer.shadowColor =  nil;
    btn.layer.shadowPath = nil;
}

static inline void configRecommondChannelItem(SRChannelItem *btn) {
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.shadowOffset =  CGSizeMake(1, 1);
    btn.layer.shadowOpacity = 0.2;
    btn.layer.shadowColor =  [UIColor blackColor].CGColor;
    btn.layer.shadowPath = pathForBtn(btn).CGPath;
}

@interface SRChannelItem ()

@property (nonatomic, copy) void (^mineChannelBlock)(SRChannelItem *);
@property (nonatomic, copy) void (^recommondChannelBlock)(SRChannelItem *);

@property (nonatomic, copy) void (^beginBlock)(SRChannelItem *);
@property (nonatomic, copy) void (^changedBlock)(SRChannelItem *, UILongPressGestureRecognizer *);
@property (nonatomic, copy) void (^endedBlock)(SRChannelItem *);

@end

@implementation SRChannelItem

- (instancetype)initWithMineChannelTouchBlock:(void(^)(SRChannelItem *))mineChannelBlock
                   recommondChannelTouchBlock:(void(^)(SRChannelItem *))recommondChannelBlock
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _mineChannelBlock = mineChannelBlock;
        _recommondChannelBlock = recommondChannelBlock;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.layer.cornerRadius = 4;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        UIImageView *deleteIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ChannelsEditing.bundle/delete_18x18_"]];
        deleteIcon.hidden = YES;
        [self addSubview:deleteIcon];
        _deleteIcon = deleteIcon;
        
        [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.deleteIcon.sr_size = CGSizeMake(18, 18);
    self.deleteIcon.sr_x = self.sr_width - 18;
    self.deleteIcon.sr_y = 0;
}

- (void)addLongPressBeginBlock:(void(^)(SRChannelItem *btn))beginBlock
                  changedBlock:(void(^)(SRChannelItem *btn, UILongPressGestureRecognizer *longPressGR))changedBlock
                    endedBlock:(void(^)(SRChannelItem *btn))endedBlock
{
    _beginBlock = beginBlock;
    _changedBlock = changedBlock;
    _endedBlock = endedBlock;
}

- (void)setModel:(SRChannelModel *)model {
    _model = model;
    
    self.frame = model.frame;
    model.item = self;
    
    if (model.isMineChannel) {
        [self setTitle:model.title forState:UIControlStateNormal];
        configMineChannelItem(self);
    } else {
        [self setTitle:[NSString stringWithFormat:@"＋%@", model.title] forState:UIControlStateNormal];
        configRecommondChannelItem(self);
    }
}

- (void)reloadData {
    if (self.model.isMineChannel) {
        [self setTitle:self.model.title forState:UIControlStateNormal];
        configMineChannelItem(self);
    } else {
        [self setTitle:[NSString stringWithFormat:@"＋%@", self.model.title] forState:UIControlStateNormal];
        configRecommondChannelItem(self);
    }
}

- (void)touchUpInsideAction:(SRChannelItem *)btn {
    if (btn.model.isMineChannel) {
        if (self.mineChannelBlock) {
            self.mineChannelBlock(btn);
        }
    } else {
        if (self.recommondChannelBlock) {
            self.recommondChannelBlock(btn);
        }
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGR {
    if (self.model.isMineChannel == NO || self.deleteIcon.hidden == YES) {
        return;
    }
    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        CGPoint center = self.center;
        [UIView animateWithDuration:0.25 animations:^{
            self.sr_width = self.sr_width + 10;
            self.sr_height = self.sr_height + 5;
            self.center = center;
        }];
        if (_beginBlock) {
            _beginBlock(self);
        }
    } else if (longPressGR.state == UIGestureRecognizerStateChanged) {
        if (_changedBlock) {
            _changedBlock(self, longPressGR);
        }
    } else if (longPressGR.state == UIGestureRecognizerStateEnded) {
        if (_endedBlock) {
            _endedBlock(self);
        }
    } else if (longPressGR.state == UIGestureRecognizerStateCancelled) {
        if (_endedBlock) {
            _endedBlock(self);
        }
    }
}

@end
