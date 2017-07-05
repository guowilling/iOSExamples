//
//  HomeCollectionViewCell.m
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HomeAnimationTool.h"

@interface HomeCollectionViewCell ()

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.coverImageView.tag = 12345;
}

- (void)setImageName:(NSString *)imageName {
    
    _imageName = [imageName copy];
    
    self.coverImageView.image = [UIImage imageNamed:imageName];
}

@end
