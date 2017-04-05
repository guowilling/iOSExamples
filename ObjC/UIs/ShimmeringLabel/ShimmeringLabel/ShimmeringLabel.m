//
//  ShimmeringLabel.m
//  ShimmeringLabel
//
//  Created by Willing Guo on 2017/4/5.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "ShimmeringLabel.h"

@interface ShimmeringLabel ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *maskLabel;
@property (strong, nonatomic) CAGradientLayer *maskLayer;

@property (assign, nonatomic, getter=isShimmering) BOOL shimmering;

@property (assign, nonatomic) CGSize textSize;

@property (assign, nonatomic) CATransform3D startTransform3D;
@property (assign, nonatomic) CATransform3D endTransform3D;

@property (strong, nonatomic) CABasicAnimation *transformAnimation;
@property (strong, nonatomic) CABasicAnimation *opacityAnimation;

@end

@implementation ShimmeringLabel

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 60, 30);
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.maskLabel];
    
    self.layer.masksToBounds = true;
    
    _shimmering = NO;
    _startTransform3D = CATransform3DIdentity;
    _endTransform3D = CATransform3DIdentity;
    _textSize = CGSizeMake(0, 0);
    _shimmeringType = ShimmeringLeftToRight;
    _infiniteLoop = YES;
    _shimmeringWidth = 20;
    _shimmeringRadius = 20;
    _shimmeringColor = [UIColor whiteColor];
    _shimmeringDuration = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)applicationWillEnterForeground {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shimmering = NO;
        [self startShimmering];
    });
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentLabel.frame = self.bounds;
    self.maskLabel.frame = self.bounds;
    self.maskLayer.frame = CGRectMake(0, 0, self.textSize.width, self.textSize.height);
}

#pragma mark - Getters and Setters

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.font = [UIFont systemFontOfSize:17];
        _contentLabel.textColor = [UIColor darkGrayColor];
    }
    return _contentLabel;
}

- (UILabel *)maskLabel {
    
    if (!_maskLabel) {
        _maskLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _maskLabel.font = [UIFont systemFontOfSize:17];
        _maskLabel.textColor = [UIColor whiteColor];
        _maskLabel.hidden = true;
    }
    return _maskLabel;
}

- (CALayer *)maskLayer {
    
    if (!_maskLayer) {
        _maskLayer = [[CAGradientLayer alloc] init];
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self freshMaskLayer];
    }
    return _maskLayer;
}

- (void)setText:(NSString *)text {
    
    _text = text;
    
    self.contentLabel.text = text;
    self.textSize = [self.contentLabel.text boundingRectWithSize:self.contentLabel.frame.size
                                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: self.contentLabel.font}
                                                         context:nil].size;
    
    [self update];
}

- (void)setFont:(UIFont *)font {
    
    _font = font;
    
    self.contentLabel.font = font;
    self.textSize = [self.contentLabel.text boundingRectWithSize:self.contentLabel.frame.size
                                                         options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: self.contentLabel.font}
                                                         context:nil].size;
    
    [self update];
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    
    self.contentLabel.textColor = textColor;
    
    [self update];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    _attributedText = attributedText;
    
    self.contentLabel.attributedText = attributedText;
    
    [self update];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    
    _numberOfLines = numberOfLines;
    
    self.contentLabel.numberOfLines = numberOfLines;
    
    [self update];
}

- (void)setShimmeringType:(ShimmeringType)shimmeringType {
    
    _shimmeringType = shimmeringType;
    
    [self update];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    
    _infiniteLoop = infiniteLoop;
    
    [self update];
}

- (void)setShimmeringWidth:(CGFloat)shimmeringWidth {
    
    _shimmeringWidth = shimmeringWidth;
    
    [self update];
}

- (void)setShimmeringRadius:(CGFloat)shimmeringRadius {
    
    _shimmeringRadius = shimmeringRadius;
    
    [self update];
}

- (void)setShimmeringColor:(UIColor *)shimmeringColor {
    
    _shimmeringColor = shimmeringColor;
    
    self.maskLabel.textColor = shimmeringColor;
    
    [self update];
}

- (void)setShimmeringDuration:(NSTimeInterval)shimmeringDuration {
    
    _shimmeringDuration = shimmeringDuration;
    
    [self update];
}

#pragma mark - Assist Methods

- (void)update {
    
    if (self.isShimmering) {
        [self stopShimmering];
        [self startShimmering];
    }
}

- (void)freshMaskLayer {
    
    if (self.shimmeringType == ShimmeringFull) {
        _maskLayer.backgroundColor = self.shimmeringColor.CGColor;
        _maskLayer.colors = nil;
        _maskLayer.locations = nil;
    } else {
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        _maskLayer.startPoint = CGPointMake(0, 0.5);
        _maskLayer.endPoint = CGPointMake(1, 0.5);
        _maskLayer.colors = @[(id)[UIColor clearColor].CGColor,
                              (id)[UIColor clearColor].CGColor,
                              (id)[UIColor whiteColor].CGColor,
                              (id)[UIColor whiteColor].CGColor,
                              (id)[UIColor clearColor].CGColor,
                              (id)[UIColor clearColor].CGColor];
        
        CGFloat sw = 1.0;
        CGFloat rw = 1.0;
        if (self.textSize.width >= 1) {
            sw = self.shimmeringWidth / self.textSize.width * 0.5;
            rw = self.shimmeringRadius / self.textSize.width;
        }
        _maskLayer.locations = @[@(0.0), @(0.5 - sw - rw), @(0.5 - sw), @(0.5 + sw), @(0.5 + sw + rw), @(1)];
        CGFloat startX = self.textSize.width * (0.5 - sw - rw);
        CGFloat endX = self.textSize.width * (0.5 + sw + rw);
        self.startTransform3D = CATransform3DMakeTranslation(-endX, 0, 1);
        self.endTransform3D = CATransform3DMakeTranslation(self.textSize.width - startX, 0, 1);
    }
}

- (CABasicAnimation *)transformAnimation {
    
    if (!_transformAnimation) {
        _transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    }
    _transformAnimation.duration = self.shimmeringDuration;
    _transformAnimation.repeatCount = self.infiniteLoop == true ? MAXFLOAT : 0;
    _transformAnimation.autoreverses = self.shimmeringType == ShimmeringAutoReverse ? true : false;
    return _transformAnimation;
}

- (CABasicAnimation *)opacityAnimation {
    
    if (!_opacityAnimation) {
        _opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _opacityAnimation.repeatCount = MAXFLOAT;
        _opacityAnimation.autoreverses = true;
        _opacityAnimation.fromValue = @(0.0);
        _opacityAnimation.toValue = @(1.0);
    }
    _opacityAnimation.duration = self.shimmeringDuration;
    return _opacityAnimation;
}

#pragma mark - Public Methods

- (void)startShimmering {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 切换到主线程串行队列, 下面代码打包成一个事件(原子操作), 加到 runloop 不用担心 isPlaying 被多个线程同时修改.
        if (self.isShimmering) {
            return;
        }
        self.shimmering = YES;
        
        self.maskLabel.attributedText = self.contentLabel.attributedText;
        self.maskLabel.text = self.contentLabel.text;
        self.maskLabel.font = self.contentLabel.font;
        self.maskLabel.numberOfLines = self.contentLabel.numberOfLines;
        self.maskLabel.hidden = NO;
        
        [self.maskLayer removeFromSuperlayer];
        [self freshMaskLayer];
        [self.maskLabel.layer addSublayer:self.maskLayer];
        
        switch (self.shimmeringType) {
            case ShimmeringLeftToRight:
            {
                self.maskLayer.transform = self.startTransform3D;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.startTransform3D];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.endTransform3D];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"shimmering"];
                break;
            }
            case ShimmeringRightToLeft:
            {
                self.maskLayer.transform = self.endTransform3D;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.endTransform3D];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.startTransform3D];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"shimmering"];
                break;
            }
            case ShimmeringAutoReverse:
            {
                self.maskLayer.transform = self.startTransform3D;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.startTransform3D];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.endTransform3D];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"shimmering"];
                break;
            }
            case ShimmeringFull:
            {
                self.maskLayer.transform = CATransform3DIdentity;
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.opacityAnimation forKey:@"shimmering"];
                break;
            }
        }
        
        self.maskLabel.layer.mask = self.maskLayer;
    });
}

- (void)stopShimmering {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isShimmering) {
            return;
        }
        self.shimmering = NO;
        [self.maskLayer removeAllAnimations];
        [self.maskLayer removeFromSuperlayer];
        self.maskLabel.hidden = YES;
    });
}

@end
