//
//  SRProductViewController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRProductViewController.h"
#import "SRProduct.h"
#import "SRProductCell.h"

static NSString * const reuseIdentifier = @"SRProductCell";

@interface SRProductViewController ()

@property (nonatomic, strong) NSArray *products;

@end

@implementation SRProductViewController

- (NSArray *)products {
    
    if (_products == nil) {
        _products = [SRProduct products];
    }
    return _products;
}

- (instancetype)init {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 最终cell的大小由布局决定, xib决定不了.
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 20;
    
    //flowLayout.headerReferenceSize = CGSizeMake(0, 50);
    //flowLayout.footerReferenceSize = CGSizeMake(0, 50);
    flowLayout.sectionInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NJIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SRProductCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.product = self.products[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRProduct *product = self.products[indexPath.row];
    
    // "newsapp://com.netease.news"
    NSString *path = [NSString stringWithFormat:@"%@://%@", product.schemes, product.identifier];
    NSURL *url = [NSURL URLWithString:path];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    } else {
        [app openURL:[NSURL URLWithString:product.appUrl]];
    }
}

@end
