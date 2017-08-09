//
//  SRChannelsViewController.m
//  SRChannelsViewControllerDemo
//
//  Created by https://github.com/guowilling on 2017/6/9.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRChannelsViewController.h"
#import "SRChannelsSelectionBar.h"
#import "UIView+SRCVCFrame.h"

@interface SRChannelsViewController () <SRChannelsBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) SRChannelsSelectionBar *selectionBar;

@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation SRChannelsViewController

#pragma mark - Lazy Load

- (SRChannelsSelectionBar *)selectionBar {
    
    if (!_selectionBar) {
        SRChannelsSelectionBar *bar = [[SRChannelsSelectionBar alloc] init];
        bar.backgroundColor = [UIColor whiteColor];
        bar.delegate = self;
        [self.view addSubview:bar];
        _selectionBar = bar;
    }
    return _selectionBar;
}

- (UIScrollView *)contentView {
    
    if (!_contentView) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.selectionBar.frame = CGRectMake(0, _barOffsetY, self.view.srcvc_width, 44);
    CGFloat contentViewY = CGRectGetMaxY(self.selectionBar.frame);
    self.contentView.frame = CGRectMake(0, contentViewY, self.view.srcvc_width, self.view.srcvc_height - contentViewY);
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.srcvc_width, 0);
}

#pragma mark - SRChannelsBarDelegate

- (void)channelsBarDidSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
    
    [self showChildVCViewsAtIndex:toIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //SRChannelsControl-Swift
    //SRChannelsControl-ObjC
    NSInteger index = self.contentView.contentOffset.x / self.contentView.srcvc_width;
    self.selectionBar.currentSelectedIndex = index;
}

#pragma mark - Public Methods

- (void)setupWithChannelTitles:(NSArray<NSString *> *)channelTitles childVCs:(NSArray <UIViewController *>*)childVCs {
    
    NSAssert(channelTitles.count != 0 || channelTitles.count == childVCs.count, @"channelTitles count must equals to childVCs count!");
    
    self.selectionBar.channelTitles = channelTitles;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    
    self.contentView.contentSize = CGSizeMake(channelTitles.count * self.view.srcvc_width, 0);
    
    [self showChildVCViewsAtIndex:0];
}

- (void)customChannelsSelectionBar:(void (^)(SRChannelsConfiguration *config))configBlock {
    
    [self.selectionBar customBar:configBlock];
}

- (void)setBarBottomLineHidden:(BOOL)barBottomLineHidden {
    
    [self.selectionBar setBarBottomLineHidden:barBottomLineHidden];
}

#pragma mark - Others

- (void)showChildVCViewsAtIndex:(NSInteger)index {
    
    if (self.childViewControllers.count == 0) {
        return;
    }
    if (index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.srcvc_width, 0) animated:NO];
    
    UIViewController *vc = self.childViewControllers[index];
    if (vc.isViewLoaded) {
        return;
    }
    vc.view.frame = CGRectMake(index * self.contentView.srcvc_width, 0, self.contentView.srcvc_width, self.contentView.srcvc_height);
    [self.contentView addSubview:vc.view];
}

@end
