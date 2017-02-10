
#import "AffineTransformController.h"

@interface AffineTransformController ()

@property (nonatomic, strong) UIView *demoView;

@end

@implementation AffineTransformController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)initView {
    
    [super initView];
    
    _demoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-100,100 ,100 )];
    _demoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_demoView];
}

- (NSArray *)operateTitleArray {
    
    return [NSArray arrayWithObjects:@"位移", @"缩放", @"旋转", @"组合", @"反转", nil];
}

- (void)clickBtn:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self positionAnimation];
            break;
        case 1:
            [self scaleAnimation];
            break;
        case 2:
            [self rotateAnimation];
            break;
        case 3:
            [self combinationAnimation];
            break;
        case 4:
            [self invertAnimation];
            break;
    }
}

- (void)positionAnimation {
    
    _demoView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0f animations:^{
        _demoView.transform = CGAffineTransformMakeTranslation(100, 100);
    }];
}

- (void)scaleAnimation {
    
    _demoView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0f animations:^{
        _demoView.transform = CGAffineTransformMakeScale(2, 2);
    }];
}

- (void)rotateAnimation {
    
    _demoView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0f animations:^{
        _demoView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)combinationAnimation {
    
    _demoView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0f animations:^{
        CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform transform2 = CGAffineTransformScale(transform1, 0.5, 0.5);
        CGAffineTransform transform3 = CGAffineTransformTranslate(transform2, 100, 100);
        _demoView.transform = transform3;
    }];
}

- (void)invertAnimation {
    
    _demoView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:1.0f animations:^{
        _demoView.transform = CGAffineTransformInvert(CGAffineTransformMakeScale(2, 2));
    }];
}

@end
