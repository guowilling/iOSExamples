//
//  SRCustomSegmentedControl.h
//  CustomUISegmentedControl
//
//  Created by 郭伟林 on 2017/6/29.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRCustomSegmentedControl : UIView

typedef void (^DidTapTitleBlock)(NSInteger fromeIndex, NSInteger toIndex);

@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, strong) UIFont  *titleFont;

@property (nonatomic, strong) UIColor *sliderColor;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat  borderWidth;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles didTapTitleBlock:(DidTapTitleBlock)didTapTitleBlock;

- (void)setSliderOffset:(CGPoint)offset;
- (void)setSliderOffset:(CGPoint)offset animated:(BOOL)animated;

@end
