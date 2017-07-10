//
//  AdvertisementLoader.m
//  LoadAdvertisementDemo
//
//  Created by 郭伟林 on 2017/7/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "AdvertisementLoader.h"
#import "AdvertisementViewController.h"
#import "UIViewController+FindNavigationController.h"
#import <UIKit/UIKit.h>

@interface AdvertisementLoader ()

@property (nonatomic, strong) UIWindow *myWindow;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, weak) UIButton *countDownBtn;

@end

@implementation AdvertisementLoader

// 通过 load: 可以做到代码无任何侵入
+ (void)load {
    
    [self shareInstance];
}

+ (instancetype)shareInstance {
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        // 注册通知
        
        // 应用启动, UIApplicationDidFinishLaunchingNotification 后 key window 及 root viewController 都有了
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self checkAD];
        }];
        
        // 进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self requestData];
        }];
        
        // 进入前台(启动应用系统不会发出这个通知)
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self checkAD];
        }];
    }
    return self;
}

- (void)requestData {
    
    // 请求最新广告数据...
}

- (void)checkAD {
    
    [self requestData];
    
    [self showAD];
}

- (void)showAD {
    
    self.count = 5;
    
    // 创建一个新的 window, 做到对原视图无干扰
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    // 设置 window 为最顶层, 防止 AlertView 弹窗等的覆盖
    window.windowLevel = UIWindowLevelStatusBar + 1;
    
    // window 的 hidden 值默认为 YES
    window.hidden = NO;
    window.alpha = 1;
    
    // 手动持有, 防止释放
    self.myWindow = window;
    
    // 布局广告视图
    [self setupAdvertisementViews];
    
    [self countDown];
}

- (void)setupAdvertisementViews {
    
    UIImageView *ADImageView = [[UIImageView alloc] initWithFrame:self.myWindow.bounds];
    ADImageView.image = [UIImage imageNamed:@"ADPic.jpg"];
    ADImageView.userInteractionEnabled = YES;
    [ADImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD)]];
    [self.myWindow addSubview:ADImageView];
    
    UIButton *countDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.myWindow.bounds.size.width - 80 - 20, 20, 80, 30)];
    countDownBtn.layer.cornerRadius = 5;
    countDownBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    countDownBtn.layer.borderWidth = 1.0;
    countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [countDownBtn addTarget:self action:@selector(dismissAD) forControlEvents:UIControlEventTouchUpInside];
    [self.myWindow addSubview:countDownBtn];
    self.countDownBtn = countDownBtn;
}

- (void)countDown {
    
    [self.countDownBtn setTitle:[NSString stringWithFormat:@"跳过广告: %zd", self.count] forState:UIControlStateNormal];
    
    if (self.count == 0) {
        [self dismissAD];
    } else {
        self.count--;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self countDown];
        });
    }
}

- (void)tapAD {
    
    // 不建议直接取 KeyWindow, 因为当有 AlertView 或者键盘弹出时, 取到的 keyWindow 不准确
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [[rootVC findNavigationController] pushViewController:[AdvertisementViewController new] animated:YES];
    
    [self dismissAD];
}

- (void)dismissAD {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.myWindow.subviews.copy enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.myWindow = nil;
    }];
}

@end
