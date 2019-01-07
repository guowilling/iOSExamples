
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
    
    CAKeyframeAnimation *keyframeAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 100, 200, 200)];
    keyframeAnima.path = bezierPath.CGPath;
    keyframeAnima.duration = 2.0f;
    [_demoView.layer addAnimation:keyframeAnima forKey:@"pathAnimation"];
}

- (void)keyFrameAnimation1 {
    
    CAKeyframeAnimation *keyframeAnima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
    keyframeAnima.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    keyframeAnima.duration = 2.0f;
    keyframeAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    keyframeAnima.delegate = self;
    [_demoView.layer addAnimation:keyframeAnima forKey:@"keyFrameAnimation"];
}

- (void)keyFrameAnimation2 {
    
    CAKeyframeAnimation *keyframeAnima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*5];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*5];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*5];
    keyframeAnima.values = @[value1,value2,value3];
    keyframeAnima.repeatCount = MAXFLOAT;
    [_demoView.layer addAnimation:keyframeAnima forKey:@"shakeAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    NSLog(@"开始动画");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"结束动画");
}

@end
