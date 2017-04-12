
#define BG_WIDTH    self.frame.size.width
#define BG_HEIGHT   self.frame.size.height
#define BALL_RADIUS 12

#import "LoadingIndicatorView.h"

@interface LoadingIndicatorView () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *ball1;
@property (nonatomic, strong) UIView *ball2;
@property (nonatomic, strong) UIView *ball3;

@end

@implementation LoadingIndicatorView

- (UIColor *)ballColor {
    
    if (!_ballColor) {
        _ballColor = [UIColor blackColor];
    }
    return _ballColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIVisualEffectView *bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        bgView.frame = CGRectMake(0, 0, BG_WIDTH, BG_HEIGHT);
        bgView.layer.cornerRadius = BALL_RADIUS / 2;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
    }
    return self;
}

- (void)show {
    
    CGFloat ballH = BG_HEIGHT / 2 - BALL_RADIUS * 0.5;
    UIView *ball_1 = [[UIView alloc] initWithFrame:CGRectMake(BG_WIDTH / 2 - BALL_RADIUS * 1.5, ballH, BALL_RADIUS, BALL_RADIUS)];
    ball_1.layer.cornerRadius = BALL_RADIUS / 2;
    ball_1.backgroundColor = self.ballColor;
    [self addSubview:ball_1];
    self.ball1 = ball_1;
    
    UIView *ball_2 = [[UIView alloc] initWithFrame:CGRectMake(BG_WIDTH / 2 - BALL_RADIUS * 0.5, ballH, BALL_RADIUS, BALL_RADIUS)];
    ball_2.layer.cornerRadius = BALL_RADIUS / 2;
    ball_2.backgroundColor = self.ballColor;
    [self addSubview:ball_2];
    self.ball2 = ball_2;
    
    UIView *ball_3 = [[UIView alloc] initWithFrame:CGRectMake(BG_WIDTH / 2 + BALL_RADIUS * 0.5, ballH, BALL_RADIUS, BALL_RADIUS)];
    ball_3.layer.cornerRadius = BALL_RADIUS / 2;
    ball_3.backgroundColor = self.ballColor;
    [self addSubview:ball_3];
    self.ball3 = ball_3;
    
    [self rotationAnimation];
}

- (void)rotationAnimation {
    
    // 围绕中心轴的点
    CGPoint centerPoint = CGPointMake(BG_WIDTH / 2 , BG_HEIGHT / 2);
    // 第一个圆的中点
    CGPoint centerBall_1 = CGPointMake(BG_WIDTH / 2 - BALL_RADIUS, BG_HEIGHT / 2);
    // 第三个圆的中点
    CGPoint centerBall_2 = CGPointMake(BG_WIDTH / 2 + BALL_RADIUS, BG_HEIGHT / 2);
    
    // 第一个圆的曲线
    UIBezierPath *path_ball_1 = [UIBezierPath bezierPath];
    [path_ball_1 moveToPoint:centerBall_1];
    [path_ball_1 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    UIBezierPath *path_ball_1_1 = [UIBezierPath bezierPath];
    [path_ball_1_1 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    [path_ball_1 appendPath:path_ball_1_1];
    
    // 第一个圆的动画
    CAKeyframeAnimation *animation_ball_1=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_1.path = path_ball_1.CGPath;
    animation_ball_1.removedOnCompletion = NO;
    animation_ball_1.fillMode = kCAFillModeForwards;
    animation_ball_1.calculationMode = kCAAnimationCubic;
    animation_ball_1.repeatCount = 1;
    animation_ball_1.duration = 1.4;
    animation_ball_1.delegate = self;
    animation_ball_1.autoreverses = NO;
    animation_ball_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball1.layer addAnimation:animation_ball_1 forKey:@"animation"];
    
    UIBezierPath *path_ball_3 = [UIBezierPath bezierPath];
    [path_ball_3 moveToPoint:centerBall_2];
    [path_ball_3 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *path_ball_3_1 = [UIBezierPath bezierPath];
    [path_ball_3_1 addArcWithCenter:centerPoint radius:BALL_RADIUS startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [path_ball_3 appendPath:path_ball_3_1];
    
    CAKeyframeAnimation *animation_ball_3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_3.path = path_ball_3.CGPath;
    animation_ball_3.removedOnCompletion = NO;
    animation_ball_3.fillMode = kCAFillModeForwards;
    animation_ball_3.calculationMode = kCAAnimationCubic;
    animation_ball_3.repeatCount = 1;
    animation_ball_3.duration = 1.4;
    animation_ball_3.autoreverses = NO;
    animation_ball_3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball3.layer addAnimation:animation_ball_3 forKey:@"rotation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self rotationAnimation];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.ball1.transform = CGAffineTransformMakeTranslation(-BALL_RADIUS, 0);
        self.ball1.transform = CGAffineTransformScale(self.ball1.transform, 0.7, 0.7);
        
        self.ball3.transform = CGAffineTransformMakeTranslation(BALL_RADIUS, 0);
        self.ball3.transform = CGAffineTransformScale(self.ball3.transform, 0.7, 0.7);
        
        self.ball2.transform = CGAffineTransformScale(self.ball2.transform, 0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn  | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.ball1.transform = CGAffineTransformIdentity;
            self.ball3.transform = CGAffineTransformIdentity;
            self.ball2.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }];
}

- (void)hide {
    
}

@end
