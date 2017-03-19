
#import "SRLeftMenu.h"
#import "UIImage+Extension.h"

@interface SRLeftMenu ()

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation SRLeftMenu

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat alpha = 0.2;
        [self setupBtnWithIcon:@"sidebar_nav_news" title:@"新闻" bgColor:SRColorRGBA(202, 68, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_nav_reading" title:@"订阅" bgColor:SRColorRGBA(190, 111, 69, alpha)];
        [self setupBtnWithIcon:@"sidebar_nav_photo" title:@"图片" bgColor:SRColorRGBA(76, 132, 190, alpha)];
        [self setupBtnWithIcon:@"sidebar_nav_video" title:@"视频" bgColor:SRColorRGBA(101, 170, 78, alpha)];
        [self setupBtnWithIcon:@"sidebar_nav_comment" title:@"跟帖" bgColor:SRColorRGBA(170, 172, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_nav_radio" title:@"电台" bgColor:SRColorRGBA(190, 62, 119, alpha)];
    }
    return self;
}

- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title bgColor:(UIColor *)bgColor {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateSelected];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.tag = self.subviews.count;
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    return btn;
}

- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(leftMenu:didSelectedButtonFromIndex:toIndex:)]) {
        [self.delegate leftMenu:self didSelectedButtonFromIndex:self.selectedButton.tag toIndex:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSInteger btnCount = self.subviews.count;
    CGFloat btnW = self.sr_width;
    CGFloat btnH = self.sr_height / btnCount;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.sr_width = btnW;
        btn.sr_height = btnH;
        btn.sr_y = i * btnH;
    }
}

@end
