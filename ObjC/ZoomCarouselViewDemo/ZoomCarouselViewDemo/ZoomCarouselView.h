//
//  ZoomCarouselView.h
//  ZoomCarouselView
//
//  Created by 郭伟林 on 17/2/17.
//  Copyright © 2017年 SR. All rights reserved.
//  ZoomCarouselView Confused?

#import <UIKit/UIKit.h>

@class ZoomCarouselView, ZoomCarouselViewCell;

@protocol ZoomCarouselViewDataSource <NSObject>

- (NSInteger)numberOfPagesInZoomCarouselView:(ZoomCarouselView *)zoomCarouselView;
- (UIView *)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView cellForPageAtIndex:(NSInteger)index;

@end

@protocol ZoomCarouselViewDelegate <NSObject>

@required
- (CGSize)sizeForCurrentPageInZoomCarouselView:(ZoomCarouselView *)zoomCarouselView;

@optional
- (void)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView didScrollToPageAtIndex:(NSInteger)index;
- (void)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView didSelectPage:(ZoomCarouselViewCell *)zoomCarouselViewCell atIndex:(NSInteger)index;

@end

@interface ZoomCarouselView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id <ZoomCarouselViewDataSource> dataSource;
@property (nonatomic, weak) id <ZoomCarouselViewDelegate>   delegate;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat otherPageAlpha;
@property (nonatomic, assign) CGFloat otherPageScale;

@property (nonatomic, assign) BOOL isAutoPaging;
@property (nonatomic, assign) BOOL isCarousel;
@property (nonatomic, assign) NSTimeInterval autoPagingInterval;

- (UIView *)dequeueReusableCell;

- (void)reloadData;

- (void)startTimer;

- (void)stopTimer;

@end
