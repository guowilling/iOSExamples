//
//  DetailViewController.h
//  AirbnbHomeAnimationDemo
//
//  Created by 郭伟林 on 2017/7/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NoParameterBlock)(void);
typedef void(^IDParameterBlock)(id);

@interface HomeDetailViewController : UIViewController

@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) NoParameterBlock showingAnimationBlock;

@property (nonatomic, strong) IDParameterBlock dismissAniamtionBlock;

@end
