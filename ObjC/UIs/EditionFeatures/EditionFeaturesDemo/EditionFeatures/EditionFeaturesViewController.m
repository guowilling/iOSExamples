//
//  EditionFeaturesViewController.m
//  
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "EditionFeaturesViewController.h"

@interface EditionFeaturesViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, strong) NSArray  *imageNames;
@property (nonatomic, copy  ) NSString *imageName;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *customButton;

@end

@implementation EditionFeaturesViewController

+ (BOOL)shouldShowEditionFeatures {
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFBundleShortVersionString"];  // the app version in the sandbox
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; // the current app version
    if ([currentVersion isEqualToString:lastVersion]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

+ (instancetype)editionFeaturesWithImageNames:(NSArray *)imageNames switchRootVCBtnImageName:(NSString *)imageName rootViewController:(UIViewController *)rootVC {
    
    return [[self alloc] initWithImageNames:imageNames switchRootVCBtnImageName:imageName rootViewController:rootVC];
}

- (instancetype)initWithImageNames:(NSArray *)imageNames switchRootVCBtnImageName:(NSString *)imageName rootViewController:(UIViewController *)rootVC {
    
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        _imageNames = imageNames;
        _imageName = imageName;
        _rootVC = rootVC;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    if (self.imageNames.count > 0) {
        CGFloat imageW = self.view.frame.size.width;
        CGFloat imageH = self.view.frame.size.height;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:({
            scrollView.frame = self.view.bounds;
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentSize = CGSizeMake(imageW * self.imageNames.count, 0);
            scrollView;
        })];

        for (int i = 0; i < self.imageNames.count; i++) {
            [scrollView addSubview:({
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView setFrame:CGRectMake(imageW * i, 0, imageW, imageH)];
                [imageView setImage:[UIImage imageNamed:_imageNames[i]]];
                if (i == self.imageNames.count - 1) {
                    [imageView setUserInteractionEnabled:YES];
                    if (_imageName) {
                        UIButton *switchBtn = [[UIButton alloc] init];
                        [switchBtn addTarget:self action:@selector(switchRootVC) forControlEvents:UIControlEventTouchUpInside];
                        [switchBtn setBackgroundImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
                        [switchBtn sizeToFit];
                        switchBtn.center = CGPointMake(self.view.center.x, imageH * 0.75);
                        [imageView addSubview:switchBtn];
                    } else {
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchRootVC)];
                        [imageView addGestureRecognizer:tap];
                    }
                }
                imageView;
            })];
        }
        
        [self.view addSubview:({
            _pageControl = [[UIPageControl alloc] init];
            _pageControl.frame = CGRectMake(0, imageH * 0.9, imageW, 20);
            _pageControl.hidesForSinglePage = YES;
            _pageControl.numberOfPages = self.imageNames.count;
            _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            _pageControl;
        })];
        
        [self.view addSubview:({
            CGFloat margin  = 20;
            CGFloat buttonW = 60;
            CGFloat buttonH = buttonW * 0.5;
            _skipButton = [[UIButton alloc] init];
            _skipButton.frame = CGRectMake(self.view.frame.size.width - margin - buttonW, self.view.frame.size.height - margin - buttonH, buttonW, buttonH);
            _skipButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            _skipButton.layer.cornerRadius = 15;
            _skipButton.layer.masksToBounds = YES;
            _skipButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            _skipButton.titleLabel.font = [UIFont systemFontOfSize:16];
            _skipButton.hidden = YES;
            [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
            [_skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_skipButton addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
             _skipButton;
        })];
    }
}

- (void)switchRootVC {
    
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVC;
                    }
                    completion:nil];
}

- (void)skipBtnAction {
    
    [self switchRootVC];
}

#pragma mark - Setters

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    [_pageControl setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    [_pageControl setPageIndicatorTintColor:pageIndicatorTintColor];
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    
    _hidePageControl = hidePageControl;
    
    _pageControl.hidden = hidePageControl;
}

- (void)setHideSkipButton:(BOOL)hideSkipButton {
    
    _hideSkipButton = hideSkipButton;
    
    _skipButton.hidden = hideSkipButton;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _pageControl.currentPage = page;
}

@end
