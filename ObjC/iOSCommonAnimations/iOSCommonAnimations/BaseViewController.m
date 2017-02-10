
#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) NSArray *operateTitleArray;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _operateTitleArray = [self operateTitleArray];
    
    [self initView];
}

- (void)initView {
    
    if (_operateTitleArray && _operateTitleArray.count > 0) {
        NSUInteger row = _operateTitleArray.count % 4 == 0 ? _operateTitleArray.count / 4 : _operateTitleArray.count / 4+1;
        UIView *operateView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- (row * 50 + 20), SCREEN_WIDTH, row * 50 + 20)];
        [self.view addSubview:operateView];
        for (int i = 0; i < _operateTitleArray.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = [self rectForBtnAtIndex:i];
            [btn setTitle:[_operateTitleArray objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.backgroundColor = [UIColor blueColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [operateView addSubview:btn];
        }
    }
}

- (CGRect)rectForBtnAtIndex:(NSUInteger)index {
    
    NSUInteger maxColumnNum = 4;
    CGFloat columnMargin = 20;
    CGFloat rowMargin = 20;
    CGFloat width = (SCREEN_WIDTH - columnMargin * 5 ) / 4;
    CGFloat height = 30;
    CGFloat offsetX = columnMargin + (index % maxColumnNum) * (width + columnMargin);
    CGFloat offsetY = rowMargin + (index / maxColumnNum) * (height + rowMargin);
    return CGRectMake(offsetX, offsetY, width, height);
}

- (void)clickBtn:(UIButton *)btn {
    
}

@end
