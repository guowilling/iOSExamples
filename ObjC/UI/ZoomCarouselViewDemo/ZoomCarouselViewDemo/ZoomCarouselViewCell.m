//
//  ZoomCarouselViewCell.m
//  ZoomCarouselView
//
//  Created by 郭伟林 on 17/2/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ZoomCarouselViewCell.h"

@implementation ZoomCarouselViewCell

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentImageView];
        [self addSubview:self.coverView];
    }
    return self;
}

@end
