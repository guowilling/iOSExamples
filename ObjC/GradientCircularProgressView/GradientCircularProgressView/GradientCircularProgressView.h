//
//  GradientCircularProgressView.h
//  GradientCircularProgressView
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientCircularProgressView : UIView

@property (nonatomic, assign) CGFloat  progress;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) UIColor *innerBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *outerBackgroundColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *progressFillColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *progressTopGradientColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *progressMidGradientColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *progressBottomGradientColor UI_APPEARANCE_SELECTOR;

@end
