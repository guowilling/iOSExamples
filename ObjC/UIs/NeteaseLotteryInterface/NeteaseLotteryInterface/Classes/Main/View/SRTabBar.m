//
//  SRTabBar.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/21.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRTabBar.h"

@interface SRTabBar ()

@property (nonatomic, strong) SRTabBarButton *selectedBtn;

@end

@implementation SRTabBar

// 自定义控件原则: 1.在 initWithFrame 方法中添加子控件; 2.在 layoutSubviews 方法中布局子控件

// init方法内部调用initWithFrame
// - (instancetype)init
// - (instancetype)initWithFrame:(CGRect)frame

// 通过xib/storybaord创建的控件会调用以下方法
// - (id)initWithCoder:(NSCoder *)aDecoder

- (void)addTabBarButtonWithNormalImageName:(NSString *)norName andDisabledImageName:(NSString *)disName {
    
    SRTabBarButton *btn = [[SRTabBarButton alloc] init];
    btn.tag = self.subviews.count;
    btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[UIImage imageNamed:norName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:disName] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.subviews.count == 0) {
        [self btnClick:btn];
    }
    [self addSubview:btn];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (int i = 0; i < self.subviews.count; i++) {
        SRTabBarButton *btn = self.subviews[i];
        CGFloat w = self.frame.size.width / self.subviews.count;
        CGFloat h = self.frame.size.height;
        CGFloat x = i * w;
        CGFloat y = 0;
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)btnClick:(SRTabBarButton *)btn {
    
    self.selectedBtn.enabled = YES;
    self.selectedBtn = btn;
    self.selectedBtn.enabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(tabBarSelectedBtn:btn:)]) {
        [self.delegate tabBarSelectedBtn:self btn:btn];
    }
}

@end

@implementation SRTabBarButton

- (void)setHighlighted:(BOOL)highlighted {

}

@end
