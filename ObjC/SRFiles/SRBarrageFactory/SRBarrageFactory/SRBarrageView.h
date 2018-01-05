//
//  SRBarrageView.h
//  SRBarrageFactory
//
//  Created by 郭伟林 on 2017/7/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRBarrageModelDelegate;

@class SRBarrageView;

@protocol SRBarrageViewDelegate <NSObject>

@required
- (NSArray<id<SRBarrageModelDelegate>> *)barrageViewDatasource;

- (NSTimeInterval)barrageViewCurrentTime;

- (UIView *)barrageView:(SRBarrageView *)barrageView barrageCellForModel:(id<SRBarrageModelDelegate>)model;

@optional
- (NSInteger)barrageViewLaneCount;

- (void)barrageView:(SRBarrageView *)barrageView didClickBarrageCell:(UIView *)barrageCell atPoint:(CGPoint)point;

@end

@interface SRBarrageView : UIView

@property (nonatomic, weak) id<SRBarrageViewDelegate> delegate;

- (void)pauseRollingBarrage;

- (void)resumeRollingBarrage;

- (void)reloadBarrage;

@end
