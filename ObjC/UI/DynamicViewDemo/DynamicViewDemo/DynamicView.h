//
//  DynamicView.h
//  DynamicViewDemo
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicView : UIView

- (instancetype)initWithFrame:(CGRect)frame referenceView:(UIView *)view;

- (void)daynamicBehavior;

@end
