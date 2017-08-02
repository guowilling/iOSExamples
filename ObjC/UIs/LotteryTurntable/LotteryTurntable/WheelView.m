//
//  WheelView.m
//  LotteryTurntable
//
//  Created by 郭伟林 on 15/9/23.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "WheelView.h"
#import "WheelButton.h"

@interface WheelView ()

@property (nonatomic, weak) IBOutlet UIImageView *centerWheel;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation WheelView

+ (instancetype)wheel {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.centerWheel.userInteractionEnabled = YES;
    
    UIImage *norImage = [UIImage imageNamed:@"LuckyAstrology"];
    UIImage *selImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    for (int index = 0; index < 12; index++) {
        WheelButton *btn = [[WheelButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        btn.bounds = CGRectMake(0, 0, 68, 143);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        CGFloat angle = (30 * index)/180.0 * M_PI;
        btn.transform = CGAffineTransformMakeRotation(angle);
        [btn addTarget:self action:@selector(selBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // Tailor image.
        CGFloat imageH = kImageHeight * [UIScreen mainScreen].scale;
        CGFloat imageW = kImageWidth * [UIScreen mainScreen].scale;
        CGFloat imageY = 0;
        CGFloat imageX = index * imageW;
        CGRect rect = CGRectMake(imageX, imageY, imageW, imageH);
        CGImageRef norCGImageRef = CGImageCreateWithImageInRect(norImage.CGImage, rect);
        [btn setImage:[UIImage imageWithCGImage:norCGImageRef]  forState:UIControlStateNormal];
        CGImageRef selCGImageRef = CGImageCreateWithImageInRect(selImage.CGImage, rect);
        [btn setImage:[UIImage imageWithCGImage:selCGImageRef]  forState:UIControlStateSelected];
        
        [self.centerWheel addSubview:btn];
    }
}

- (void)selBtn:(UIButton *)btn {
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
}

- (void)startRotating {
    
    if (self.displayLink) {
        return;
    }
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(centerWheelRotation)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink = displayLink;
}

- (void)centerWheelRotation {
    
    self.centerWheel.transform = CGAffineTransformRotate(self.centerWheel.transform, M_PI / 60);
}

- (void)stopRotating {
    
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (IBAction)startBtnClick:(id)sender {
    
    [UIView animateWithDuration:1.0 animations:^{
        self.centerWheel.transform = CGAffineTransformRotate(self.centerWheel.transform, M_PI);
    } completion:nil];
    
//    self.userInteractionEnabled = NO;
//    CABasicAnimation *anima = [CABasicAnimation animation];
//    anima.keyPath = @"transform.rotation";
//    anima.byValue = @(M_PI);
//    anima.duration = 2.0;
//    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anima.delegate = self;
//    [self.centerWheel.layer addAnimation:anima forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self.userInteractionEnabled = YES;
}

@end
