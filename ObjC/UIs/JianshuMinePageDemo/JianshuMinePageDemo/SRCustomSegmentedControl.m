//
//  SRCustomSegmentedControl.m
//  CustomUISegmentedControl
//
//  Created by 郭伟林 on 2017/6/29.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRCustomSegmentedControl.h"

#define SRRGBColor(R, G, B) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0]

#define kTitleButtonTag 55

@interface SRCustomSegmentedControl ()

@property (nonatomic, copy) DidTapTitleBlock didTapTitleBlock;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableArray *allTitleButtons;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation SRCustomSegmentedControl

- (NSMutableArray *)allTitleButtons {
    
    if (!_allTitleButtons) {
        _allTitleButtons = [NSMutableArray array];
    }
    return _allTitleButtons;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles didTapTitleBlock:(DidTapTitleBlock)didTapTitleBlock {
    
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        _didTapTitleBlock = didTapTitleBlock;
        
        _titleNormalColor = [UIColor blackColor];
        _titleSelectColor = [UIColor whiteColor];
        _sliderColor = [UIColor colorWithWhite:0 alpha:0.75];
        _borderColor = [UIColor blackColor];
        _borderWidth = 1.0f;
        
        [self.layer setCornerRadius:(self.frame.size.height * 0.5)];
        [self.layer setMasksToBounds:YES];
        [self.layer setBorderWidth:self.borderWidth];
        [self.layer setBorderColor:self.borderColor.CGColor];
        
        [self setupSliderView];
        
        [self setupTitleButtons];
    }
    return self;
}

- (void)setupSliderView {
    
    UIView *sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / self.titles.count, self.frame.size.height)];
    sliderView.backgroundColor = _sliderColor;
    [sliderView.layer setCornerRadius:(sliderView.frame.size.height * 0.5)];
    [sliderView.layer setMasksToBounds:YES];
    [self addSubview:sliderView];
    _sliderView = sliderView;
}

- (void)setupTitleButtons {
    
    NSInteger count = self.titles.count;
    CGFloat btnW = self.frame.size.width / count;
    CGFloat btnH = self.frame.size.height;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = i * self.frame.size.width / count;
        titleBtn.frame = CGRectMake(btnX, 0, btnW, btnH);
        titleBtn.tag = i + kTitleButtonTag;
        titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.adjustsImageWhenHighlighted = NO;
        [titleBtn setTitle:self.titles[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
        [self.allTitleButtons addObject:titleBtn];
    }
    
    [self buttonClick:self.allTitleButtons[0]];
}

- (void)buttonClick:(UIButton *)button {
    
    [self.selectButton setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    
    [button setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    
    _selectButton = button;
    
    [self setSliderOffset:CGPointMake([self.allTitleButtons indexOfObject:button] * self.frame.size.width / self.titles.count, 0) animated:YES];
    
    NSInteger selectIndex = [self.allTitleButtons indexOfObject:button];
    if (self.didTapTitleBlock) {
        self.didTapTitleBlock(self.lastIndex, selectIndex);
    }
    self.lastIndex = selectIndex;
}

#pragma mark - Public Methods

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    
    _titleNormalColor = titleNormalColor;
    
    for (UIButton *button in self.allTitleButtons) {
        [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    }
    
    [self.selectButton setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
    
    _titleSelectColor = titleSelectColor;
    
    [self.selectButton setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
}

- (void)setTitleFont:(UIFont *)titleFont {
    
    _titleFont = titleFont;
    
    for (UIButton *button in self.allTitleButtons) {
        button.titleLabel.font = titleFont;
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    
    _sliderColor = sliderColor;
    
    self.sliderView.backgroundColor = self.sliderColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}

- (void)setSliderOffset:(CGPoint)offset {
    
    [self setSliderOffset:offset animated:NO];
}

- (void)setSliderOffset:(CGPoint)offset animated:(BOOL)animated {
    
    CGRect frame = self.sliderView.frame;
    frame.origin.x = offset.x;
    [UIView animateWithDuration:animated ? 0.3 : 0.0 animations:^{
        self.sliderView.frame = frame;
    }];
    
    NSInteger currentIndex = (NSInteger)self.sliderView.center.x / (self.frame.size.width / self.titles.count);
    _selectButton = self.allTitleButtons[currentIndex];
    
    NSMutableArray *needUpdatebuttons = [NSMutableArray array];
    for (UIButton *button in self.allTitleButtons) {
        CGFloat intersection = CGRectIntersection(button.frame, self.sliderView.frame).size.width;
        if (intersection <= 0) {
            continue;
        }
        [needUpdatebuttons addObject:button];
    }
    
    if (needUpdatebuttons.count <= 1) {
        return;
    }
    UIButton *leftButton = needUpdatebuttons.firstObject;
    CGFloat leftButtonR = [self getButtonTitleColor:leftButton RGB:0];
    CGFloat leftButtonG = [self getButtonTitleColor:leftButton RGB:1];
    CGFloat leftButtonB = [self getButtonTitleColor:leftButton RGB:2];
    [leftButton setTitleColor:SRRGBColor(leftButtonR, leftButtonG, leftButtonB) forState:UIControlStateNormal];
    
    UIButton *rightButton = needUpdatebuttons.lastObject;
    CGFloat rightButtonR = [self getButtonTitleColor:rightButton RGB:0];
    CGFloat rightButtonG = [self getButtonTitleColor:rightButton RGB:1];
    CGFloat rightButtonB = [self getButtonTitleColor:rightButton RGB:2];
    [rightButton setTitleColor:SRRGBColor(rightButtonR, rightButtonG, rightButtonB) forState:UIControlStateNormal];
}

#pragma mark - Tools Methods

- (CGFloat)getButtonTitleColor:(UIButton *)button RGB:(NSInteger)index {
    // index 0: R, 1: G, 2:B
    CGFloat leftRGB[3];
    CGFloat rightRGB[3];
    RGBValue(leftRGB, self.titleNormalColor);
    RGBValue(rightRGB, self.titleSelectColor);
    CGFloat intersection = CGRectIntersection(button.frame, self.sliderView.frame).size.width;
    CGFloat value = intersection / button.frame.size.width;
    if ([button isEqual:self.selectButton]) {
        return leftRGB[index] + value * (rightRGB[index] - leftRGB[index]);
    } else {
        return rightRGB[index] + (1 - value) * (leftRGB[index] - rightRGB[index]);
    }
}

void RGBValue(CGFloat RGB[3], UIColor *color)
{
    unsigned char data[4];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    size_t width = 1, height = 1, bitsPerComponent = 8, bytesPerRow = 4;
    uint32_t bitmapInfo = 1;
    CGContextRef context = CGBitmapContextCreate(&data, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(space);
    for (NSInteger i = 0; i < 3; i++) {
        RGB[i] = data[i];
    }
}

@end
