
#import "SRHeaderView.h"
#import "UIButton+SRSugar.h"

@implementation SRHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *closeBtn = UIButton.button(UIButtonTypeCustom).image([UIImage imageNamed:@"ChannelsEditing.bundle/close_14x14_"], UIControlStateNormal);
        closeBtn.frame = CGRectMake(15, 0, 40, 40);
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)closeBtnAction:(UIButton *)btn {
    if (self.closeBtnActionBlock) {
        self.closeBtnActionBlock();
    }
}

@end
