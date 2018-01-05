//
//  SRBarrageView.m
//  SRBarrageFactory
//
//  Created by 郭伟林 on 2017/7/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRBarrageView.h"
#import "SRBarrageModelProtocol.h"
#import "CALayer+SRBarrage.h"

#define kDisplayInterval 0.1

@interface SRBarrageView ()

@property (nonatomic, strong) NSMutableArray<id<SRBarrageModelDelegate>> *barrageModels;

@property (nonatomic, strong) NSMutableArray *barrageCells;

@property (nonatomic, strong) NSTimer *rollingTimer;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *barrageLaneWaitingTimes;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *barrageLaneLeftTimes;

@property (nonatomic, assign, getter=isPaused) BOOL paused;

@property (nonatomic, assign) NSInteger laneCount;

@end

@implementation SRBarrageView

#pragma mark - Lifecycle

- (void)dealloc {
    
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    [self loadBarrage];
}

#pragma mark - Lazy Load

- (NSMutableArray *)barrageLaneWaitingTimes {
    
    if (!_barrageLaneWaitingTimes) {
        _barrageLaneWaitingTimes = [NSMutableArray arrayWithCapacity:self.laneCount];
        for (int i = 0; i < self.laneCount; i++) {
            [_barrageLaneWaitingTimes addObject:@0];
        }
    }
    return _barrageLaneWaitingTimes;
}

- (NSMutableArray *)barrageLaneLeftTimes {
    
    if (!_barrageLaneLeftTimes) {
        _barrageLaneLeftTimes = [NSMutableArray arrayWithCapacity:self.laneCount];
        for (int i = 0; i < self.laneCount; i++) {
            [_barrageLaneLeftTimes addObject:@0];
        }
    }
    return _barrageLaneLeftTimes;
}

- (NSMutableArray *)barrageCells {
    
    if (!_barrageCells) {
        _barrageCells = [NSMutableArray array];
    }
    return _barrageCells;
}

#pragma mark - Timer

- (void)fireTimer {
    
    if (_rollingTimer) {
        [self stopTimer];
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:kDisplayInterval target:self selector:@selector(rollingTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _rollingTimer = timer;
}

- (void)stopTimer {
    
    if (_rollingTimer) {
        [self.rollingTimer invalidate];
        [self setRollingTimer:nil];
    }
}

- (void)rollingTimerAction {
    
    if (self.isPaused) {
        return;
    }
    
    NSInteger count = self.barrageLaneLeftTimes.count;
    for (int i = 0; i < count; i ++) {
        if (self.barrageLaneWaitingTimes[i].doubleValue <= 0) {
            self.barrageLaneWaitingTimes[i] = @0;
        } else {
            self.barrageLaneWaitingTimes[i] = @(self.barrageLaneWaitingTimes[i].doubleValue - kDisplayInterval);
        }
        
        if (self.barrageLaneLeftTimes[i].doubleValue <= 0) {
            self.barrageLaneLeftTimes[i] = @0;
        } else {
            self.barrageLaneLeftTimes[i] = @(self.barrageLaneLeftTimes[i].doubleValue - kDisplayInterval);
        }
    }
    
    [self.barrageModels sortUsingComparator:^NSComparisonResult(id<SRBarrageModelDelegate>  _Nonnull obj1, id<SRBarrageModelDelegate>  _Nonnull obj2) {
        if (obj1.launchTime <= obj2.launchTime) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *deleteModels = [NSMutableArray array];
    for (id<SRBarrageModelDelegate> model in self.barrageModels) {
        NSTimeInterval currentTime = [self.delegate barrageViewCurrentTime];
        if (model.launchTime > currentTime) {
            break;
        }
        
        BOOL isModelCanLaunchNow = NO;
        isModelCanLaunchNow = [self checkBarrageCanLaunchNowWithModel:model];
        if (isModelCanLaunchNow) {
            [deleteModels addObject:model];
        } else {
            break;
        }
    }
    
    [self.barrageModels removeObjectsInArray:deleteModels];
}

#pragma mark - Assist Methods

- (BOOL)checkBarrageCanLaunchNowWithModel:(id<SRBarrageModelDelegate>)model {
    
    BOOL canLaunchNow = NO;
    for (int i = 0; i < self.laneCount; i++) {
        if (self.barrageLaneWaitingTimes[i].doubleValue > 0) {
            continue;
        }
        UIView *barrageCell = [self.delegate barrageView:self barrageCellForModel:model];
        NSTimeInterval leftTime = self.barrageLaneLeftTimes[i].doubleValue;
        float speed = (self.bounds.size.width + barrageCell.bounds.size.width) / model.duration;
        CGFloat distance = speed * leftTime;
        if (distance > self.bounds.size.width) {
            continue;
        }
        self.barrageLaneWaitingTimes[i] = @(barrageCell.bounds.size.width / (self.bounds.size.width + barrageCell.bounds.size.width) * model.duration);
        self.barrageLaneLeftTimes[i] = @(model.duration);
        
        [self processBarrageCell:barrageCell index:i];
        [self launchingBarrageCell:barrageCell duration:model.duration];
        canLaunchNow = YES;
        break;
    }
    return canLaunchNow;
}

- (void)processBarrageCell:(UIView *)barrageCell index:(NSInteger)i {
    
    CGFloat laneHeight = self.bounds.size.height / self.laneCount;
    CGFloat y = i * laneHeight;
    CGFloat x = self.bounds.size.width;
    CGRect frame = barrageCell.frame;
    frame.origin = CGPointMake(x, y);
    barrageCell.frame = frame;
    [self addSubview:barrageCell];
    [self.barrageCells addObject:barrageCell];
}

- (void)launchingBarrageCell:(UIView *)barrageCell duration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frame = barrageCell.frame;
        frame.origin.x = -barrageCell.bounds.size.width;
        barrageCell.frame = frame;
    } completion:^(BOOL finished) {
        [barrageCell removeFromSuperview];
        [self.barrageCells removeObject:barrageCell];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self];
    for (UIView *barrageCell in self.barrageCells) {
        CGRect presentationLayerFrame = barrageCell.layer.presentationLayer.frame;
        if (CGRectContainsPoint(presentationLayerFrame, point)) {
            if ([self.delegate respondsToSelector:@selector(barrageView:didClickBarrageCell:atPoint:)]) {
                [self.delegate barrageView:self didClickBarrageCell:barrageCell atPoint:point];
            }
            break;
        }
    }
}

- (void)loadBarrage {
    
    self.barrageModels = [self.delegate barrageViewDatasource].mutableCopy;
    
    if ([self.delegate respondsToSelector:@selector(barrageViewLaneCount)]) {
        self.laneCount = [self.delegate barrageViewLaneCount];
    } else {
        self.laneCount = 5;
    }
    
    [self fireTimer];
}

#pragma mark - Public Methods

- (void)pauseRollingBarrage {
    
    if (self.isPaused) {
        return;
    }
    self.paused = YES;
    [self stopTimer];
    [[self.barrageCells valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimation)];
}

- (void)resumeRollingBarrage {
    
    if (!self.isPaused) {
        return;
    }
    self.paused = NO;
    [self fireTimer];
    [[self.barrageCells valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimation)];
}

- (void)reloadBarrage {
    
    [self stopTimer];
    
    if (self.barrageCells.count > 0) {
        [self.barrageCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.barrageCells removeAllObjects];
    }
    
    [self loadBarrage];
}

@end
