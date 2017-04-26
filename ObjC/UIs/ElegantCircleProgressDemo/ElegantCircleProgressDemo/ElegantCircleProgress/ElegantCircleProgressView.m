
#import "ElegantCircleProgressView.h"
#import "ElegantCircleProgress.h"

@interface ElegantCircleProgressView ()

@property (nonatomic, strong) ElegantCircleProgress *elegantCircleProgress;

@property (nonatomic, strong) UILabel *percentLabel;

@end

@implementation ElegantCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _percentLabel.textColor = [UIColor whiteColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = [UIFont systemFontOfSize:75];
    _percentLabel.text = @"0%";
    [self addSubview:_percentLabel];
    
    _elegantCircleProgress = [[ElegantCircleProgress alloc] initWithFrame:self.bounds lineWidth:12];
    [self addSubview:_elegantCircleProgress];
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    _elegantCircleProgress.progress = progress;
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

@end
