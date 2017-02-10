
#import "BaseAnimationController.h"
#import "AppDelegate.h"

@interface BaseAnimationController()

@property (nonatomic, strong) UIView *demoView;

@end

@implementation BaseAnimationController

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
    
    return @[@"位移", @"透明度", @"缩放", @"旋转", @"背景色"];
}

- (void)clickBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self positionAnimation];
            break;
        case 1:
            [self opacityAniamtion];
            break;
        case 2:
            [self scaleAnimation];
            break;
        case 3:
            [self rotateAnimation];
            break;
        case 4:
            [self backgroundAnimation];
            break;
    }
}

// CABasicAnimation:
// 如果 fillMode = kCAFillModeForwards 和 removedOnComletion = NO, 那么在动画执行完毕后, 图层会保持显示动画执行后的状态.
// 但在实质上, 图层的属性值还是动画执行前的值, 并没有真正被改变.

/**
 位移动画
 */
- (void)positionAnimation {
    
    // CABasicAnimation
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT / 2)];
    basicAnima.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    basicAnima.duration = 1.0f;
    basicAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_demoView.layer addAnimation:basicAnima forKey:@"positionAnimation"];

    // UIView block
//    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
//    [UIView animateWithDuration:1.0f animations:^{
//        _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
//    } completion:^(BOOL finished) {
//        _demoView.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50, 50, 50);
//    }];
    
    
    // UIView [begin/commit]
//    _demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0f];
//    _demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
//    [UIView commitAnimations];
}

/**
 *  透明度动画
 */
- (void)opacityAniamtion {
    
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnima.fromValue = [NSNumber numberWithFloat:1.0f];
    basicAnima.toValue = [NSNumber numberWithFloat:0.1f];
    basicAnima.duration = 1.0f;
    basicAnima.fillMode = kCAFillModeForwards;
    basicAnima.removedOnCompletion = NO;
    [_demoView.layer addAnimation:basicAnima forKey:@"opacityAniamtion"];
}

/**
 *  缩放动画
 */
- (void)scaleAnimation {
    
//    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    basicAnima.toValue = [NSNumber numberWithFloat:2.0f];
//    basicAnima.duration = 1.0f;
//    [_demoView.layer addAnimation:basicAnima forKey:@"scaleAnimation"];
//    
//    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    basicAnima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
//    basicAnima.duration = 1.0f;
//    [_demoView.layer addAnimation:basicAnima forKey:@"scaleAnimation"];
    
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    basicAnima.toValue = [NSNumber numberWithFloat:0.5f];
    basicAnima.duration = 1.0f;
    [_demoView.layer addAnimation:basicAnima forKey:@"scaleAnimation"];
}

/**
 *  旋转动画
 */
- (void)rotateAnimation {
    
    // 绕着 z 轴旋转 (@"transform.rotation.z" == @"transform.rotation")
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnima.toValue = [NSNumber numberWithFloat:M_PI];
    basicAnima.duration = 1.0f;
    [_demoView.layer addAnimation:basicAnima forKey:@"rotateAnimation"];
    
    
//    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
//    basicAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
//    basicAnima.duration = 1.0f;
//    basicAnima.repeatCount = MAXFLOAT;
//    [_demoView.layer addAnimation:basicAnima forKey:@"rotateAnimation"];
    
    
//    _demoView.transform = CGAffineTransformMakeRotation(0);
//    [UIView animateWithDuration:1.0f animations:^{
//        _demoView.transform = CGAffineTransformMakeRotation(M_PI);
//    }];
}

/**
 *  背景色变化动画
 */
- (void)backgroundAnimation {
    
    CABasicAnimation *basicAnima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    basicAnima.toValue = (id)[UIColor yellowColor].CGColor;
    basicAnima.duration = 1.0f;
    basicAnima.fillMode = kCAFillModeForwards;
    basicAnima.removedOnCompletion = NO;
    [_demoView.layer addAnimation:basicAnima forKey:@"backgroundAnimation"];
}

@end
