//
//  MyTabBar.m
//  CustomTabBar
//
//  Created by Willing Guo on 17/1/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <objc/runtime.h>
#import "MyTabBar.h"
#import "UIView+Extension.h"
#import "UIImage+Image.h"

@interface MyTabBar ()

@property (nonatomic, weak) UIButton *plusBtn;

@end

@implementation MyTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
        
        UIButton *plusBtn = [[UIButton alloc] init];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(plusBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        _plusBtn = plusBtn;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.plusBtn.size = CGSizeMake(self.plusBtn.currentBackgroundImage.size.width,
                                   self.plusBtn.currentBackgroundImage.size.height);
    self.plusBtn.centerX = self.centerX;
    self.plusBtn.centerY = self.height * 0.5 - 20;
  
    UILabel *plusLabel = [[UILabel alloc] init];
    plusLabel.text = @"发布";
    plusLabel.textColor = [UIColor grayColor];
    plusLabel.font = [UIFont systemFontOfSize:12];
    //[plusLabel sizeToFit];
    plusLabel.textAlignment = NSTextAlignmentCenter;
    plusLabel.size = _plusBtn.size;
    plusLabel.centerX = self.plusBtn.centerX;
    plusLabel.centerY = CGRectGetMaxY(self.plusBtn.frame) + 10;
    [self addSubview:plusLabel];
    
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            btn.width = self.width / 5;
            btn.x = btn.width * btnIndex;
            btnIndex++;
            if (btnIndex == 2) {
                btnIndex++;
            }
        }
    }
    [self bringSubviewToFront:self.plusBtn];
}

- (void)plusBtnAction {
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.myDelegate tabBarDidClickPlusBtn:self];
    }
}

// 为了让凸出的部分点击也有反应重写hitTest方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 必须判断, 任何界面发生点击事件都是会调用这个方法的.
    if (self.isHidden == NO) { // 当前页面tabbar没有隐藏, 那么肯定是在导航控制器的根控制器页面.
        // 当前tabbar的触摸点转换到发布按钮的身上.
        CGPoint newPoint = [self convertPoint:point toView:self.plusBtn];
        // 如果转换后的点是在发布按钮身上, 那么处理点击事件最合适的view就是发布按钮.
        if ([self.plusBtn pointInside:newPoint withEvent:event]) {
            return self.plusBtn;
        } else { // 如果不在发布按钮身上, 直接让系统处理就可以了.
            return [super hitTest:point withEvent:event];
        }
    } else { // tabbar隐藏了, 说明已经push到其他的页面了直接让系统处理就可以了.
        return [super hitTest:point withEvent:event];
    }
}

@end
