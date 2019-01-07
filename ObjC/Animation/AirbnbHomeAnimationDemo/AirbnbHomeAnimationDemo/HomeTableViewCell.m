//
//  HomeTableViewCell.m
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "HomeCollectionViewCell.h"

static NSString *HomeCollectionViewCellID = @"HomeCollectionViewCellID";

@interface HomeTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:HomeCollectionViewCellID];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(250, 250 * 2.0 / 3.0 + 44);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0 ;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagesName:(NSArray *)imagesName {
    
    _imagesName = imagesName;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewCellID forIndexPath:indexPath];
    cell.imageName = self.imagesName[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(homeTableViewCellDidSelectCollcetionView:itemAtIndexPath:)]) {
        [self.delegate homeTableViewCellDidSelectCollcetionView:collectionView itemAtIndexPath:indexPath];
    }
}

@end
