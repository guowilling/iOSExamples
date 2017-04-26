
#import "ElegantCircleProgress.h"

static CGFloat dotMargin = 0.5;

@interface ElegantCircleProgress ()

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) UIImageView *dotView;

@end

@implementation ElegantCircleProgress

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth {
    
    if ([super initWithFrame:frame]) {
        _lineWidth = lineWidth;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGFloat centerY = self.bounds.size.height * 0.5;
    CGFloat radius = (self.bounds.size.width - _lineWidth) * 0.5;
    
    // 贝塞尔路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                              radius:radius
                                                          startAngle:(-0.5f*M_PI)
                                                            endAngle:1.5f*M_PI
                                                           clockwise:YES];
    
    // 背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor = [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1].CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = bezierPath.CGPath;
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    // 进度条圆环
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = bezierPath.CGPath;
    _progressLayer.strokeEnd = 0;
    
    // 颜色梯度圆环
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 10) {
        [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
    }
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer]; // 通过 progressLayer 来截取渐变层
    [self.layer addSublayer:gradientLayer];
    
    // 进度条尾部元素
    _dotView = [[UIImageView alloc] init];
    _dotView.frame = CGRectMake(0, 0, _lineWidth - dotMargin * 2, _lineWidth - dotMargin * 2);
    _dotView.backgroundColor = [UIColor blackColor];
    _dotView.image = [UIImage imageNamed:@"dot"];
    _dotView.layer.masksToBounds = YES;
    _dotView.layer.cornerRadius = _dotView.bounds.size.width * 0.5;
    _dotView.hidden = YES;
    [self addSubview:_dotView];
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    _progressLayer.strokeEnd = progress;
    
    [self updateEndPoint];
    
    [_progressLayer removeAllAnimations];
}

- (void)updateEndPoint {
    
    CGFloat angle = M_PI * 2 * _progress; // 弧度
    float radius = (self.bounds.size.width - _lineWidth) / 2.0;
    int index = (angle) / M_PI_2; // 用于区分在第几象限内
    float needAngle = angle - index * M_PI_2; // 用于计算 正弦 / 余弦 的角度
    float x = 0, y = 0; //用于保存 _dotView 的 frame
    switch (index) {
        case 0:
            NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
    }
    
    CGRect rect = _dotView.frame;
    rect.origin.x = x + dotMargin;
    rect.origin.y = y + dotMargin;
    _dotView.frame = rect;
    
    [self bringSubviewToFront:_dotView];
    _dotView.hidden = NO;
    if (_progress == 0 || _progress == 1) {
        _dotView.hidden = YES;
    }
}

@end
