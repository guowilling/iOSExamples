//
//  ZoomCarouselView.m
//  ZoomCarouselView
//
//  Created by 郭伟林 on 17/2/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ZoomCarouselView.h"
#import "ZoomCarouselViewCell.h"

@interface ZoomCarouselView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) NSInteger orginPageCount;
@property (nonatomic, assign) NSInteger totalPageCount;

@property (nonatomic, assign) NSRange visibleRange;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSMutableArray *reusableCells;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, assign) NSInteger timerPage;

@end

@implementation ZoomCarouselView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _pageSize = self.bounds.size;
    _totalPageCount = 0;
    _isAutoPaging = YES;
    _isCarousel = YES;
    _currentPageIndex = 0;
    _otherPageAlpha = 1.0;
    _otherPageScale = 1.0;
    _autoPagingInterval = 5.0;
    
    _visibleRange = NSMakeRange(0, 0);
    
    _reusableCells = [NSMutableArray array];
    _cells = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    /*****************************
     由于 UIScrollView 滚动之后会调用自己的 layoutSubviews 以及父视图的 layoutSubviews,
     为了避免滚动 scrollview 引起 layoutSubviews 的调用, 所以给 scrollView 加一层父视图.
     *****************************/
    UIView *superViewOfScrollView = [[UIView alloc] initWithFrame:self.bounds];
    [superViewOfScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [superViewOfScrollView setBackgroundColor:[UIColor clearColor]];
    [superViewOfScrollView addSubview:_scrollView];
    [self addSubview:superViewOfScrollView];
}

#pragma mark - Timer

- (void)startTimer {
    
    if (self.orginPageCount <= 1 || !self.isAutoPaging || !self.isCarousel) {
        return;
    }
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoPagingInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)nextPage {
    
    self.timerPage++;
    
    [_scrollView setContentOffset:CGPointMake(self.timerPage * self.pageSize.width, 0) animated:YES];
}

#pragma mark - Cells

- (void)reloadData {
    
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[ZoomCarouselViewCell class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self stopTimer];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInZoomCarouselView:)]) {
        _orginPageCount = [_dataSource numberOfPagesInZoomCarouselView:self];
        if (self.isCarousel) {
            _totalPageCount = _orginPageCount == 1 ? 1 : [_dataSource numberOfPagesInZoomCarouselView:self] * 3;
        } else {
            _totalPageCount = _orginPageCount == 1 ? 1 : [_dataSource numberOfPagesInZoomCarouselView:self];
        }
        if (_totalPageCount == 0) {
            return;
        }
        if (self.pageControl) {
            self.pageControl.numberOfPages = _orginPageCount;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sizeForCurrentPageInZoomCarouselView:)]) {
        _pageSize = [_delegate sizeForCurrentPageInZoomCarouselView:self];
    }
    
    _visibleRange = NSMakeRange(0, 0);
    [_reusableCells removeAllObjects];
    [_cells removeAllObjects];
    for (NSInteger index = 0; index < _totalPageCount; index++) {
        [_cells addObject:[NSNull null]];
    }
    
    _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
    _scrollView.contentSize = CGSizeMake(_pageSize.width * _totalPageCount, _pageSize.height);
    _scrollView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));;
    
    if (_orginPageCount > 1) {
        if (self.isCarousel) {
            [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
            self.timerPage = self.orginPageCount;
            [self startTimer];
        } else {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            self.timerPage = self.orginPageCount;
        }
    }
    
    [self updateCellsWithContentOffset:_scrollView.contentOffset];
    [self updateVisibleCells];
}

- (void)updateCellsWithContentOffset:(CGPoint)offset {
    
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    NSInteger startIndex = 0;
    for (int i = 0; i < _cells.count; i++) {
        if (_pageSize.width * (i + 1) > startPoint.x) {
            startIndex = i;
            break;
        }
    }
    
    NSInteger endIndex = startIndex;
    for (NSInteger i = startIndex; i < _cells.count; i++) {
        if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i + 2 == [_cells count]) {
            endIndex = i + 1;
            break;
        }
    }
    
    startIndex = MAX(startIndex - 1, 0);
    endIndex = MIN(endIndex + 1, [_cells count] - 1);
    
    self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        NSParameterAssert(i >= 0 && i < _cells.count);
        id cell = _cells[i];
        if ([cell isKindOfClass:[NSNull class]]) {
            cell = [_dataSource zoomCarouselView:self cellForPageAtIndex:i % self.orginPageCount];
            NSAssert(cell != nil, @"Datasource Must Not return nil");
            [_cells replaceObjectAtIndex:i withObject:cell];
            UIView *viewCell = (UIView *)cell;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
            [viewCell addGestureRecognizer:singleTap];
            viewCell.tag = i % self.orginPageCount;
            viewCell.frame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);
            if (viewCell.superview) {
                return;
            }
            [_scrollView addSubview:cell];
        }
    }
    
    for (int i = 0; i < startIndex; i ++) {
        [self removeCellAtIndex:i];
    }
    
    for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
        [self removeCellAtIndex:i];
    }
}

- (void)removeCellAtIndex:(NSInteger)index {
    
    id cell = _cells[index];
    if ([cell isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [self queueReusableCell:cell];
    
    if (((UIView *)cell).superview) {
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)queueReusableCell:(UIView *)cell {
    
    [_reusableCells addObject:cell];
}

- (UIView *)dequeueReusableCell {
    
    ZoomCarouselViewCell *cell = [_reusableCells lastObject];
    if (cell) {
        [_reusableCells removeLastObject];
        return cell;
    }
    return nil;
}

- (void)updateVisibleCells {
    
    if (_otherPageAlpha == 1.0 && _otherPageScale == 1.0) {
        return;
    }
    CGFloat offsetX = _scrollView.contentOffset.x;
    for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
        ZoomCarouselViewCell *cell = [_cells objectAtIndex:i];
        CGFloat origin = cell.frame.origin.x;
        CGFloat delta = fabs(origin - offsetX);
        CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);
        if (delta < _pageSize.width) {
            cell.coverView.alpha = (delta / _pageSize.width) * _otherPageAlpha;
            CGFloat inset = (_pageSize.width * (1 - _otherPageScale)) * (delta / _pageSize.width) / 2.0;
            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset * 2) / _pageSize.width, (_pageSize.height-inset * 2) / _pageSize.height, 1.0);
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
        } else {
            cell.coverView.alpha = _otherPageAlpha;
            CGFloat inset = _pageSize.width * (1 - _otherPageScale) / 2.0 ;
            cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset*2)/_pageSize.width, (_pageSize.height-inset*2)/_pageSize.height, 1.0);
            cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.orginPageCount == 0) {
        return;
    }
    
    NSInteger pageIndex = (int)floor(_scrollView.contentOffset.x / _pageSize.width) % self.orginPageCount;
    if (self.isCarousel) {
        if (self.orginPageCount > 1) {
            if (scrollView.contentOffset.x / _pageSize.width >= 2 * self.orginPageCount) {
                [scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                self.timerPage = self.orginPageCount;
            }
            if (scrollView.contentOffset.x / _pageSize.width <= self.orginPageCount - 1) {
                [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _pageSize.width, 0) animated:NO];
                self.timerPage = 2 * self.orginPageCount;
            }
        } else {
            pageIndex = 0;
        }
    }
    
    [self updateCellsWithContentOffset:scrollView.contentOffset];
    [self updateVisibleCells];
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        [self.pageControl setCurrentPage:pageIndex];
    }
    
    if (_currentPageIndex == pageIndex) {
        return;
    }
    _currentPageIndex = pageIndex;
    if ([_delegate respondsToSelector:@selector(zoomCarouselView:didScrollToPageAtIndex:)]) {
        [_delegate zoomCarouselView:self didScrollToPageAtIndex:_currentPageIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.orginPageCount > 1 && self.isAutoPaging && self.isCarousel) {
        [self startTimer];
        if (self.timerPage == floor(_scrollView.contentOffset.x / _pageSize.width)) {
            self.timerPage = floor(_scrollView.contentOffset.x / _pageSize.width) + 1;
        } else {
            self.timerPage = floor(_scrollView.contentOffset.x / _pageSize.width);
        }
    }
}

#pragma mark - Others

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x;
        newPoint.y = point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y;
        if ([_scrollView pointInside:newPoint withEvent:event]) {
            return [_scrollView hitTest:newPoint withEvent:event];
        }
        return _scrollView;
    }
    return nil;
}

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(zoomCarouselView:didSelectPage:atIndex:)]) {
        [self.delegate zoomCarouselView:self didSelectPage:(ZoomCarouselViewCell *)gesture.view atIndex:gesture.view.tag];
    }
}

- (void)setPageControl:(UIPageControl *)pageControl {
    
    _pageControl = pageControl;
    
    [self addSubview:pageControl];
}

@end
