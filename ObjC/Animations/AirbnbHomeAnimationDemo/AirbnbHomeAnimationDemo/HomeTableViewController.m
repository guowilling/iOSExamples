//
//  HomeTableViewController.m
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "HomeTableViewController.h"
#import "HomeTableViewCell.h"
#import "HomeCollectionViewCell.h"
#import "HomeDetailViewController.h"
#import "HomeAnimationTool.h"

@interface HomeTableViewController () <HomeTableViewCellDelegate>

@property (nonatomic, strong) NSArray *imagesName;

@property (nonatomic, strong) HomeAnimationTool *animationTool;

@end

@implementation HomeTableViewController

- (HomeAnimationTool *)animationTool {
    
    if (!_animationTool) {
        _animationTool = [HomeAnimationTool new];
    }
    return _animationTool;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Airbnb";
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.rowHeight = 300;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:HomeTableViewCellID];
    
    {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            NSString *imageName = [NSString stringWithFormat:@"Airbnb0%@", @(i)];
            [arrayM addObject:imageName];
        }
        self.imagesName = [arrayM copy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imagesName = self.imagesName;
    cell.delegate = self;
    return cell;
}

#pragma mark - HomeTableViewCellDelegate

- (void)homeTableViewCellDidSelectCollcetionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeDetailViewController *destVC = [[HomeDetailViewController alloc] init];
    HomeCollectionViewCell *collectionCell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    destVC.coverImage = collectionCell.coverImageView.image;
    destVC.dismissAniamtionBlock = [self.animationTool begainAnimationWithCollectionView:collectionView
                                                                didSelectItemAtIndexPath:indexPath
                                                                      fromViewController:self
                                                                        toViewController:destVC
                                                                             finishBlock:destVC.showingAnimationBlock];
}

@end
