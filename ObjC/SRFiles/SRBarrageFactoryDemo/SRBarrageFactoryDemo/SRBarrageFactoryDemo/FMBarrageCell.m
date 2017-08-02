//
//  FMBarrageCell.m
//  SRBarrageFactoryDemo
//
//  Created by 郭伟林 on 2017/8/2.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "FMBarrageCell.h"

@interface FMBarrageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

@end

@implementation FMBarrageCell

+ (instancetype)barrageCell {
    
    FMBarrageCell *cell = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
    return cell;
}

- (void)setBarrageModel:(FMBarrageModel *)barrageModel {
    
    _barrageModel = barrageModel;
    
    [self.contentBtn setAttributedTitle:barrageModel.content forState:UIControlStateNormal];
    CGSize size = [barrageModel.content.string sizeWithAttributes:@{NSFontAttributeName: self.contentBtn.titleLabel.font}];
    self.bounds = CGRectMake(0, 0, 80 + size.width, self.bounds.size.height);
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    
    if (self.setupAvatarBlock) {
        self.setupAvatarBlock(self.userAvatar, self.barrageModel.avatarURLString);
    }
}

@end
