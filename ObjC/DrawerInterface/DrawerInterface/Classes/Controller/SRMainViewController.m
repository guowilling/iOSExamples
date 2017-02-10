
#import "SRMainViewController.h"
#import "SRNavigationController.h"
#import "SRNewsViewController.h"
#import "SRNavTitleView.h"
#import "UIBarButtonItem+Extension.h"
#import "SRLeftMenu.h"
#import "SRRightMenuController.h"

#define SRCoverTag 100
#define SRNavShowAnimDuration 0.25
#define SRLeftMenuY 50
#define SRLeftMenuW 150
#define SRLeftMenuH 300

@interface SRMainViewController () <SRLeftMenuDelegate>

@property (nonatomic, weak) SRNavigationController *showingNavC;
@property (nonatomic, weak) SRLeftMenu *leftMenu;
@property (nonatomic, strong) SRRightMenuController *rightMenuVC;

@end

@implementation SRMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupAllChildVcs];
    
    [self setupLeftMenu];
    
    [self setupRightMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.showingNavC = self.childViewControllers[0];
    [self.view addSubview:self.showingNavC.view];
}

- (void)setupAllChildVcs {
    
    UIViewController *news = [[UIViewController alloc] init];
    [self addVc:news title:@"新闻"];
    UIViewController *reading = [[UIViewController alloc] init];
    [self addVc:reading title:@"订阅"];
    UIViewController *photo = [[UIViewController alloc] init];
    [self addVc:photo title:@"图片"];
    UIViewController *video = [[UIViewController alloc] init];
    [self addVc:video title:@"视频"];
    UIViewController *comment = [[UIViewController alloc] init];
    [self addVc:comment title:@"跟帖"];
    UIViewController *radio = [[UIViewController alloc] init];
    [self addVc:radio title:@"电台"];
}

- (void)addVc:(UIViewController *)vc title:(NSString *)title {
    
    vc.view.backgroundColor = SRRandomColor;
    SRNavTitleView *titleView = [[SRNavTitleView alloc] init];
    titleView.title = title;
    vc.navigationItem.titleView = titleView;
    vc.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftMenuClick) norImage:@"top_navigation_menuicon" highImage:nil];
    vc.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightMenuClick) norImage:@"top_navigation_infoicon" highImage:nil];
    SRNavigationController *nav = [[SRNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)setupLeftMenu {
    
    SRLeftMenu *leftMenu = [[SRLeftMenu alloc] init];
    leftMenu.frame = CGRectMake(0, SRLeftMenuY, SRLeftMenuW, SRLeftMenuH);
    leftMenu.delegate = self;
    [self.view insertSubview:leftMenu atIndex:1];
    self.leftMenu = leftMenu;
}

- (void)setupRightMenu {
    
    SRRightMenuController *rightMenuVC = [[SRRightMenuController alloc] init];
    rightMenuVC.view.frame = self.view.bounds;
    rightMenuVC.view.sr_width = 250;
    rightMenuVC.view.sr_x = self.view.sr_width - rightMenuVC.view.sr_width;
    [self.view insertSubview:rightMenuVC.view atIndex:1];
    self.rightMenuVC = rightMenuVC;
}

#pragma mark - Monitor Methods

- (void)leftMenuClick {
    
    self.leftMenu.hidden = NO;
    self.rightMenuVC.view.hidden = YES;
    [UIView animateWithDuration:SRNavShowAnimDuration animations:^{
        CGFloat scale =  (SRScreenH - 2 * SRLeftMenuY) / SRScreenH;
        self.showingNavC.view.transform = CGAffineTransformMakeScale(scale, scale);
        self.showingNavC.view.transform = CGAffineTransformTranslate(self.showingNavC.view.transform, SRLeftMenuW, 0);
        
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.showingNavC.view.bounds;
        cover.tag = SRCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.showingNavC.view addSubview:cover];
    }];
}

- (void)coverClick:(UIView *)cover {
    
    [UIView animateWithDuration:SRNavShowAnimDuration animations:^{
        self.showingNavC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)rightMenuClick {
    
    self.leftMenu.hidden = YES;
    self.rightMenuVC.view.hidden = NO;
    [UIView animateWithDuration:SRNavShowAnimDuration animations:^{
        CGFloat scale = (SRScreenH - 2 * SRLeftMenuY) / SRScreenH;
        self.showingNavC.view.transform = CGAffineTransformMakeScale(scale, scale);
        self.showingNavC.view.transform = CGAffineTransformTranslate(self.showingNavC.view.transform, -self.rightMenuVC.view.sr_width, 0);
        
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = self.showingNavC.view.bounds;
        cover.tag = SRCoverTag;
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.showingNavC.view addSubview:cover];
    } completion:^(BOOL finished) {
        [self.rightMenuVC didShow];
    }];
}

#pragma mark - SRLeftMenuDelegate

- (void)leftMenu:(SRLeftMenu *)menu didSelectedButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    SRNavigationController *oldNav = self.childViewControllers[fromIndex];
    [oldNav.view removeFromSuperview];
    SRNavigationController *newNav = self.childViewControllers[toIndex];
    newNav.view.transform = oldNav.view.transform;
    newNav.view.layer.shadowColor = [UIColor blackColor].CGColor;
    newNav.view.layer.shadowOffset = CGSizeMake(-3, 0);
    newNav.view.layer.shadowOpacity = 0.2;
    [self.view addSubview:newNav.view];
    [self setShowingNavC:newNav];
    
    [self coverClick:[newNav.view viewWithTag:SRCoverTag]];
}

@end
