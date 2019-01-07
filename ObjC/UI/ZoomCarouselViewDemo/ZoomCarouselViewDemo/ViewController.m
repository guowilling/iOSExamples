//
//  ViewController.m
//  ZoomCarouselViewDemo
//
//  Created by 郭伟林 on 17/2/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "ZoomCarouselView.h"
#import "ZoomCarouselViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <ZoomCarouselViewDataSource, ZoomCarouselViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UIScrollView *containerScrollView;

@end

@implementation ViewController

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        for (int index = 0; index < 5; index++) {
            NSString *imageName = [NSString stringWithFormat:@"coldplay%02d.jpg", index];
            UIImage *image = [UIImage imageNamed:imageName];
            [_images addObject:image];
        }
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /****************************
     使用导航控制器 UINavigationController 时, 如果控制器中不存在 UIScrollView 或者继承自 UIScrollView 的控件,
     需要使用 UIScrollView 作为 ZoomCarouselView 的容器 View 才能正常显示.
     ****************************/
    _containerScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_containerScrollView];
    
    [self setupZoomCarouselViewNoCarousel];
    
    [self setupZoomCarouselViewCarousel];
}

- (void)setupZoomCarouselViewNoCarousel {
    ZoomCarouselView *zoomCarouselView = [[ZoomCarouselView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenWidth * 0.5)];
    zoomCarouselView.delegate = self;
    zoomCarouselView.dataSource = self;
    zoomCarouselView.otherPageAlpha = 0.55;
    zoomCarouselView.otherPageScale = 0.95;
    zoomCarouselView.isCarousel = NO;
    [_containerScrollView addSubview:zoomCarouselView];
    [zoomCarouselView reloadData];
}

- (void)setupZoomCarouselViewCarousel {
    ZoomCarouselView *zoomCarouselView = [[ZoomCarouselView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, ScreenWidth * 0.5 + 25)];
    zoomCarouselView.delegate = self;
    zoomCarouselView.dataSource = self;
    zoomCarouselView.otherPageAlpha = 0.5;
    zoomCarouselView.otherPageScale = 0.9;
    zoomCarouselView.isAutoPaging = YES;
    zoomCarouselView.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, zoomCarouselView.frame.size.height - 25 - 10, ScreenWidth, 10)];
    [_containerScrollView addSubview:zoomCarouselView];
    [zoomCarouselView reloadData];
}

#pragma mark - ZoomCarouselViewDataSource

- (NSInteger)numberOfPagesInZoomCarouselView:(ZoomCarouselView *)zoomCarouselView {
    return self.images.count;
}

- (UIView *)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView cellForPageAtIndex:(NSInteger)index {
    ZoomCarouselViewCell *cell = (ZoomCarouselViewCell *)[zoomCarouselView dequeueReusableCell];
    if (!cell) {
        cell = [[ZoomCarouselViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, ScreenWidth * 0.5)];
        cell.tag = index;
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
    }
    cell.contentImageView.image = self.images[index];
    return cell;
}

#pragma mark - ZoomCarouselViewDelegate

- (CGSize)sizeForCurrentPageInZoomCarouselView:(ZoomCarouselView *)zoomCarouselView {
    return CGSizeMake(ScreenWidth - 100, ScreenWidth * 0.5);
}

- (void)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView didScrollToPageAtIndex:(NSInteger)index {
    NSLog(@"%zd", index);
}

- (void)zoomCarouselView:(ZoomCarouselView *)zoomCarouselView didSelectPage:(ZoomCarouselViewCell *)zoomCarouselViewCell atIndex:(NSInteger)index {
    NSLog(@"%zd", index);
}

@end
