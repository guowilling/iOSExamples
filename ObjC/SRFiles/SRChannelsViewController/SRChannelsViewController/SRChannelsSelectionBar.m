//
//  SRChannelsBar.m
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRChannelsSelectionBar.h"
#import "SRChannelsConfiguration.h"
#import "UIView+SRCVCFrame.h"

#define kMinMargin 30

@interface SRChannelsSelectionBar ()

@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, strong) NSMutableArray<UIButton *> *channelBtns;

@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, weak) UIView *bottomLine;

@property (nonatomic, strong) SRChannelsConfiguration *barConfig;

@end

@implementation SRChannelsSelectionBar

#pragma mark - Lazy Load

- (NSMutableArray<UIButton *> *)channelBtns {
    
    if (!_channelBtns) {
        _channelBtns = [NSMutableArray array];
    }
    return _channelBtns;
}

- (UIScrollView *)contentView {
    
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (UIView *)indicatorView {
    
    if (!_indicatorView) {
        CGFloat indicatorH = self.barConfig.indicatorViewHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.srcvc_height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.barConfig.indicatorViewColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = self.barConfig.bottomLineViewColor;
        bottomLine.hidden = YES;
        [self.contentView addSubview:bottomLine];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

- (SRChannelsConfiguration *)barConfig {
    
    if (!_barConfig) {
        _barConfig = [SRChannelsConfiguration defaultConfig];
    }
    return _barConfig;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _currentSelectedIndex = 0;
        self.backgroundColor = self.barConfig.barBackgroundColor;
    }
    return self;
}

#pragma mark - Public Methdos

- (void)setChannelTitles:(NSArray<NSString *> *)channelTitles {
    
    _channelTitles = channelTitles;
    
    [self.channelBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.channelBtns removeAllObjects];
    
    for (NSString *title in channelTitles) {
        UIButton *channelBtn = [[UIButton alloc] init];
        channelBtn.tag = self.channelBtns.count;
        channelBtn.titleLabel.font = self.barConfig.channelFont;
        [channelBtn setTitle:title forState:UIControlStateNormal];
        [channelBtn setTitleColor:self.barConfig.channelNormalColor forState:UIControlStateNormal];
        [channelBtn setTitleColor:self.barConfig.channelSelectedColor forState:UIControlStateSelected];
        [channelBtn addTarget:self action:@selector(channelBtnAction:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:channelBtn];
        [self.channelBtns addObject:channelBtn];
    }
    
    _lastBtn = self.channelBtns[0];
    _lastBtn.selected = YES;
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    
    if (self.channelBtns.count == 0) {
        return;
    }
    if (currentSelectedIndex < 0 || currentSelectedIndex > self.channelBtns.count - 1) {
        return;
    }
    _currentSelectedIndex = currentSelectedIndex;
    UIButton *btn = self.channelBtns[currentSelectedIndex];
    [self channelBtnAction:btn];
}

- (void)setBarBottomLineHidden:(BOOL)hidden {
    
    self.bottomLine.hidden = hidden;
}

- (void)customBar:(void (^)(SRChannelsConfiguration *config))configBlock {
    
    if (configBlock) {
        configBlock(self.barConfig);
    }
    
    self.backgroundColor = self.barConfig.barBackgroundColor;
    self.indicatorView.backgroundColor = self.barConfig.indicatorViewColor;
    for (UIButton *btn in self.channelBtns) {
        [btn setTitleColor:self.barConfig.channelNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.barConfig.channelSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.barConfig.channelFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Actions

- (void)channelBtnAction:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(channelsBarDidSelectIndex:fromIndex:)]) {
        [self.delegate channelsBarDidSelectIndex:btn.tag fromIndex:_lastBtn.tag];
    }
    
    _currentSelectedIndex = btn.tag;
    
    _lastBtn.selected = NO;
    btn.selected = YES;
    _lastBtn = btn;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.srcvc_width = btn.srcvc_width + self.barConfig.indicatorViewExtraWidth * 2;
        self.indicatorView.srcvc_centerX = btn.srcvc_centerX;
    }];
    
    CGFloat scrollX = btn.srcvc_centerX - self.contentView.srcvc_width * 0.5;
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.srcvc_width) {
        scrollX = self.contentView.contentSize.width - self.contentView.srcvc_width;
    }
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.channelBtns) {
        [btn sizeToFit];
        totalBtnWidth += btn.srcvc_width;
    }
    
    CGFloat margin = (self.srcvc_width - totalBtnWidth) / (self.channelTitles.count + 1);
    if (margin < kMinMargin) {
        margin = kMinMargin;
    }
    
    CGFloat lastX = margin;
    for (UIButton *btn in self.channelBtns) {
        [btn sizeToFit];
        btn.srcvc_x = lastX;
        btn.srcvc_y = (self.srcvc_height - btn.srcvc_height - self.barConfig.indicatorViewHeight) * 0.5;
        lastX += btn.srcvc_width + margin;
    }
    
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    UIButton *btn = self.channelBtns[self.currentSelectedIndex];
    self.indicatorView.srcvc_width = btn.srcvc_width + self.barConfig.indicatorViewExtraWidth * 2;
    self.indicatorView.srcvc_centerX = btn.srcvc_centerX;
    self.indicatorView.srcvc_height = self.barConfig.indicatorViewHeight;
    self.indicatorView.srcvc_y = self.srcvc_height - self.indicatorView.srcvc_height;
    
    self.bottomLine.frame = CGRectMake(0, self.srcvc_height - 0.5, self.srcvc_width, 0.5);
}

@end
