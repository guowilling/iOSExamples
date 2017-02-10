//
//  SRProductCell.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRProductCell.h"

@interface SRProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SRProductCell

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    NSLog(@"%s", __func__);
//    if (self = [super initWithCoder:aDecoder]) {
//        self.iconImageView.layer.cornerRadius = 8;
//        self.iconView.clipsToBounds = YES;
//    }
//    return self;
//}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 调用awakeFormNid时sb连线才完成
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.clipsToBounds =YES;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setProduct:(SRProduct *)product {
    
    _product = product;
    
    self.iconImageView.image = [UIImage imageNamed:product.icon];
    self.titleLabel.text = product.title;
}

@end
