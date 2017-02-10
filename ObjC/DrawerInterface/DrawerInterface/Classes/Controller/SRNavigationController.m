
#import "SRNavigationController.h"

@implementation SRNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[UIImage imageNamed:@"top_navigation_background"] forBarMetrics:UIBarMetricsDefault];
}

@end
