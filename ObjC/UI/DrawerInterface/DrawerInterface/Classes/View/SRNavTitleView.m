
#import "SRNavTitleView.h"

@implementation SRNavTitleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self setImage:[UIImage imageNamed:@"navbar_netease"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        self.sr_height = self.currentImage.size.height;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    [self setTitle:title forState:UIControlStateNormal];
    NSDictionary *attrs = @{NSFontAttributeName : self.titleLabel.font};
    CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    self.sr_width = titleW + self.titleEdgeInsets.left + self.currentImage.size.width;
}

@end
