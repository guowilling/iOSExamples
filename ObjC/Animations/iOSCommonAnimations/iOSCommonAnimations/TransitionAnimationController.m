
#import "TransitionAnimationController.h"

@interface TransitionAnimationController ()

@property (nonatomic, strong) UIView  *demoView;
@property (nonatomic, strong) UILabel *demoLabel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation TransitionAnimationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initView {
    
    [super initView];
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-200, 200, 300)];
    [self.view addSubview:_demoView];
    
    _demoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_demoView.frame)/2-20, CGRectGetHeight(_demoView.frame)/2-20, 40, 40)];
    _demoLabel.textAlignment = NSTextAlignmentCenter;
    _demoLabel.font = [UIFont systemFontOfSize:40];
    [_demoView addSubview:_demoLabel];
    
    [self changeView:YES];
}

- (NSArray *)operateTitleArray {
    
    return @[@"fade", @"moveIn", @"push", @"reveal", @"cube", @"suck", @"oglFlip", @"ripple", @"Curl", @"UnCurl", @"caOpen", @"caClose"];
}

- (void)clickBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self fadeAnimation];
            break;
        case 1:
            [self moveInAnimation];
            break;
        case 2:
            [self pushAnimation];
            break;
        case 3:
            [self revealAnimation];
            break;
        case 4:
            [self cubeAnimation];
            break;
        case 5:
            [self suckEffectAnimation];
            break;
        case 6:
            [self oglFlipAnimation];
            break;
        case 7:
            [self rippleEffectAnimation];
            break;
        case 8:
            [self pageCurlAnimation];
            break;
        case 9:
            [self pageUnCurlAnimation];
            break;
        case 10:
            [self cameraIrisHollowOpenAnimation];
            break;
        case 11:
            [self cameraIrisHollowCloseAnimation];
            break;
    }
}

#pragma mark - public API
// type:
//    kCATransitionFade;
//    kCATransitionMoveIn;
//    kCATransitionPush;
//    kCATransitionReveal;
// subType:
//    kCATransitionFromRight;
//    kCATransitionFromLeft;
//    kCATransitionFromTop;
//    kCATransitionFromBottom;

- (void)fadeAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade; // 动画类型
    transition.subtype = kCATransitionFromRight; // 动画方向
    //anima.startProgress = 0.5; // 动画起点
    //anima.endProgress = 0.5; // 动画终点
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"fadeAnimation"];
}

- (void)moveInAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"moveInAnimation"];
}

- (void)pushAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"pushAnimation"];
}

- (void)revealAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"revealAnimation"];
}

#pragma mark - private API
// Don't be surprised if Apple rejects your app for including those effects, and especially don't be surprised if your app starts behaving strangely after an OS update.

- (void)cubeAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"revealAnimation"];
}

- (void)suckEffectAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"suckEffect";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"suckEffectAnimation"];
}

- (void)oglFlipAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"oglFlipAnimation"];
}

- (void)rippleEffectAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"rippleEffectAnimation"];
}

- (void)pageCurlAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"pageCurlAnimation"];
}

- (void)pageUnCurlAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"pageUnCurl";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"pageUnCurlAnimation"];
}

- (void)cameraIrisHollowOpenAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"cameraIrisHollowOpen";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"cameraIrisHollowOpenAnimation"];
}

- (void)cameraIrisHollowCloseAnimation {
    
    [self changeView:YES];
    
    CATransition *transition = [CATransition animation];
    transition.type = @"cameraIrisHollowClose";
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0f;
    [_demoView.layer addAnimation:transition forKey:@"cameraIrisHollowCloseAnimation"];
}

- (void)changeView:(BOOL)isUp {
    
    if (_index > 3) {
        _index = 0;
    }
    if (_index < 0) {
        _index = 3;
    }
    
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor orangeColor], [UIColor purpleColor]];
    NSArray *titles = @[@"1", @"2", @"3", @"4"];
    _demoView.backgroundColor = colors[_index];
    _demoLabel.text = titles[_index];
    if (isUp) {
        _index++;
    } else {
        _index--;
    }
}

@end
