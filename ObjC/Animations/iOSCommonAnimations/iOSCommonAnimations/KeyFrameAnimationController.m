
#import "KeyFrameAnimationController.h"

@interface KeyFrameAnimationController () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *demoView;

@end

@implementation KeyFrameAnimationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initView {
    
    [super initView];
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100,100 ,100)];
    _demoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_demoView];
}

- (NSArray *)operateTitleArray {
    
    return [NSArray arrayWithObjects:@"路径动画", @"关键帧动画1", @"关键帧动画2", nil];
}

- (void)clickBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self pathAnimation];
            break;
        case 1:
            [self keyFrameAnimation1];
            break;
        case 2:
            [self keyFrameAnimation2];
            break;
    }
}

- (void)pathAnimation {
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
    anima.path = path.CGPath;
    anima.duration = 2.0f;
    [_demoView.layer addAnimation:anima forKey:@"pathAnimation"];
}

- (void)keyFrameAnimation1 {
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    anima.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    anima.duration = 2.0f;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anima.delegate = self;
    [_demoView.layer addAnimation:anima forKey:@"keyFrameAnimation"];
}

- (void)keyFrameAnimation2 {
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*5];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*5];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*5];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = MAXFLOAT;
    [_demoView.layer addAnimation:anima forKey:@"shakeAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    NSLog(@"开始动画");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"结束动画");
}

@end
