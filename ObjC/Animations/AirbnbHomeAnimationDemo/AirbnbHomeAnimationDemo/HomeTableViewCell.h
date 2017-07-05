//
//  HomeTableViewCell.h
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeTableViewCell, HomeCollectionViewCell;

@protocol HomeTableViewCellDelegate <NSObject>

@optional
- (void)homeTableViewCellDidSelectCollcetionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)indexPath;

@end

static NSString * const HomeTableViewCellID = @"HomeTableViewCellID";

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HomeTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *imagesName;

@end
