//
//  ViewController.m
//  JianshuMinePageDemo
//
//  Created by 郭伟林 on 2017/7/3.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "SRCustomSegmentedControl.h"

#define SRScreenW [UIScreen mainScreen].bounds.size.width
#define SRScreenH [UIScreen mainScreen].bounds.size.height

#define kHeaderViewH 240 
#define kSegmentedControlH 44

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *middleTableView;
@property (nonatomic, weak) UITableView *rightTableView;

@property (nonatomic, weak) UIView *headerContainer;
@property (nonatomic, weak) SRCustomSegmentedControl *segmentedControl;

@property (nonatomic, weak) UIImageView *avatar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupAvatar];
    
    [self setupContentScrollView];
    
    [self setupHeaderContainer];
}

- (void)setupAvatar {
    UIView *avatarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    avatarView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = avatarView;
    
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 36, 36)];
    avatar.image = [UIImage imageNamed:@"avatar.jpg"];
    avatar.layer.cornerRadius = 36 * 0.5;
    avatar.layer.masksToBounds = YES;
    avatar.transform = CGAffineTransformMakeScale(2, 2);
    [avatarView addSubview:avatar];
    _avatar = avatar;
}

- (void)setupContentScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(3 * SRScreenW, 0);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    _contentScrollView = scrollView;
    
    self.leftTableView = [self tableViewWithX:0];
    self.middleTableView = [self tableViewWithX:SRScreenW];
    self.rightTableView = [self tableViewWithX:SRScreenW * 2];
}

- (UITableView *)tableViewWithX:(CGFloat)x {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, 0, SRScreenW, SRScreenH - 0)];
    tableView.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SRScreenW, kHeaderViewH + kSegmentedControlH)];
    tableView.tableHeaderView = headerView;
    [self.contentScrollView addSubview:tableView];
    return tableView;
}

- (void)setupHeaderContainer {
    HeaderView *headerView = [HeaderView headerView:(CGRect){0, 0, SRScreenW, kHeaderViewH}];
    
    SRCustomSegmentedControl *segmentedControl = [[SRCustomSegmentedControl alloc] initWithFrame:CGRectMake(0, kHeaderViewH, SRScreenW, kSegmentedControlH) titles:@[@"动态", @"文章", @"更多"] didTapTitleBlock:^(NSInteger fromIndex, NSInteger toIndex) {
        self.contentScrollView.contentOffset = CGPointMake(toIndex * SRScreenW, 0);
        [self synchronizationTableViewsOffsetY];
    }];
    _segmentedControl = segmentedControl;
    [segmentedControl setTitleNormalColor:[UIColor blackColor]];
    [segmentedControl setTitleSelectColor:[UIColor redColor]];
    [segmentedControl setSliderColor:[UIColor redColor]];
    [segmentedControl setBorderColor:[UIColor clearColor]];
    [segmentedControl setBorderWidth:0];
    
    // 去掉圆角
    segmentedControl.layer.cornerRadius = segmentedControl.sliderView.layer.cornerRadius = 0;
    
    // 添加上下线条
    for (NSInteger i = 0; i < 2; i++) {
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        line.frame = CGRectMake(0, (kSegmentedControlH - 0.5) * i, SRScreenW, 0.5);
        [segmentedControl addSubview:line];
    }
    
    // 调整 sliderView 的 frame
    CGRect frame = segmentedControl.sliderView.frame;
    frame.origin.y = frame.size.height - 1.5;
    frame.size.height = 1;
    segmentedControl.sliderView.frame = frame;
    
    UIView *headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SRScreenW, CGRectGetMaxY(segmentedControl.frame))];
    headerContainer.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    [headerContainer addSubview:headerView];
    [headerContainer addSubview:segmentedControl];
    [self.view addSubview:headerContainer];
    _headerContainer = headerContainer;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.998 alpha:1];
    if (tableView == self.leftTableView) {
        cell.textLabel.text = @"Left TabbleView";
    } else if (tableView == self.middleTableView) {
        cell.textLabel.text = @"Middle TableView";
    } else {
        cell.textLabel.text = @"Right TableView";
    }
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self synchronizationTableViewsOffsetY];
    }
}

- (void)synchronizationTableViewsOffsetY {
    CGFloat maxOffsetY = self.leftTableView.contentOffset.y;
    if (self.middleTableView.contentOffset.y > maxOffsetY) {
        maxOffsetY = self.middleTableView.contentOffset.y;
    }
    if (self.rightTableView.contentOffset.y > maxOffsetY) {
        maxOffsetY = self.rightTableView.contentOffset.y;
    }
    
    if (maxOffsetY > 240) {
        if (self.leftTableView.contentOffset.y < 240) {
            self.leftTableView.contentOffset = CGPointMake(0, 240);
        }
        if (self.middleTableView.contentOffset.y < 240) {
            self.middleTableView.contentOffset = CGPointMake(0, 240);
        }
        if (self.rightTableView.contentOffset.y < 240) {
            self.rightTableView.contentOffset = CGPointMake(0, 240);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self.segmentedControl setSliderOffset:CGPointMake(scrollView.contentOffset.x / 3, 0)];
        return;
    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (contentOffsetY < kHeaderViewH) {
            // 同步三个 tableView 的偏移量
            self.leftTableView.contentOffset = self.middleTableView.contentOffset = self.rightTableView.contentOffset = scrollView.contentOffset;
            
            // 改变 headerContainer 的 y
            CGRect frame = self.headerContainer.frame;
            CGFloat y = -scrollView.contentOffset.y;
            frame.origin.y = y;
            self.headerContainer.frame = frame;
        } else if (contentOffsetY >= kHeaderViewH) {
            // 不同步三个 tableView 的偏移量, 并使 headerContainer 的 y 停留在固定位置.
            CGRect frame = self.headerContainer.frame;
            frame.origin.y = -kHeaderViewH;
            self.headerContainer.frame = frame;
        }
        
        // 处理顶部头像
        // 缩放
        CGFloat scale = 0;
        if (scrollView.contentOffset.y > 100) {
            scale = 1;
        } else if (scrollView.contentOffset.y <= 0) {
            scale = 0;
        } else {
            scale = scrollView.contentOffset.y / 100;
        }
        self.avatar.transform = CGAffineTransformMakeScale(2 - scale, 2 - scale);
        CGRect frame = self.avatar.frame;
        frame.origin.y = (1 - scale) * 8;
        self.avatar.frame = frame;
    }
}

@end
