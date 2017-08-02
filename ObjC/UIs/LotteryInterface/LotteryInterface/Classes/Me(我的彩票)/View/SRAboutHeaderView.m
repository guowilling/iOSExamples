//
//  SRAboutHeaderView.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRAboutHeaderView.h"

@implementation SRAboutHeaderView

+ (instancetype)headerView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SRAboutHeaderView" owner:nil options:nil] lastObject];
}

@end
