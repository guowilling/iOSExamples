//
//  SRTitleButton.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/21.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRTitleButton.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#ifdef __IPHONE_7_0
#else
#endif

@interface SRTitleButton ()

@property (nonatomic, strong) UIFont *titleFont;

@end

@implementation SRTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.titleFont = [UIFont systemFontOfSize:16];
    self.titleLabel.font = self.titleFont;
    self.imageView.contentMode = UIViewContentModeCenter;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleH = contentRect.size.height;
    NSString *title = self.currentTitle;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSFontAttributeName] = self.titleFont;
    CGRect  titleRect = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:md context:nil];
    CGFloat titleW = titleRect.size.width;
    return CGRectMake(0, 0, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageW = 16;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width - imageW;
#warning 此方法中UIButton的子控件都是空不能在此设置图片的显示样式
    //self.imageView.contentMode = UIViewContentModeCenter;
    return CGRectMake(imageX, 0, imageW, imageH);
}

@end
