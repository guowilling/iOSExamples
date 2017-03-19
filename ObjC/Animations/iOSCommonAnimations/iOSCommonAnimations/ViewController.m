//
//  ViewController.m
//  iOSCommonAnimations
//
//  Created by 郭伟林 on 17/2/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "BaseAnimationController.h"
#import "KeyFrameAnimationController.h"
#import "GroupAnimationController.h"
#import "TransitionAnimationController.h"
#import "AffineTransformController.h"

@interface ViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *menuArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"iOSCommonAnimations";
    
    _menuArray = [NSArray arrayWithObjects:@"基础动画", @"仿射形变动画", @"关键帧动画", @"组动画", @"过渡动画", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TABLE_VIEW_ID = @"table_view_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_VIEW_ID];
    }
    cell.textLabel.text = [_menuArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *viewController;
    switch (indexPath.row) {
        case 0:
            viewController = [[BaseAnimationController alloc] init];
            viewController.title = _menuArray[0];
            break;
        case 1:
            viewController = [[AffineTransformController alloc] init];
            viewController.title = _menuArray[1];
            break;
        case 2:
            viewController = [[KeyFrameAnimationController alloc] init];
            viewController.title = _menuArray[2];
            break;
        case 3:
            viewController = [[GroupAnimationController alloc] init];
            viewController.title = _menuArray[3];
            break;
        case 4:
            viewController = [[TransitionAnimationController alloc] init];
            viewController.title = _menuArray[4];
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
