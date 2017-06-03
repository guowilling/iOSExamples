//
//  SRNewFeaturesViewController.h
//  
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeaturesViewController : UIViewController

/**
 Whether to hide pageControl, default is NO which means show pageControl.
 */
@property (nonatomic, assign) BOOL hidePageControl;

/**
 Whether to hide skip Button, default is YES which means hide skip Button.
 */
@property (nonatomic, assign) BOOL hideSkipButton;

/**
 The current page indicator tint color, default is [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 The other page indicator tint color, default is [UIColor lightGrayColor].
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Only the first start app need show new features.

 @return YES to show, NO not to show.
 */
+ (BOOL)shouldShowNewFeature;

/**
 Creates and returns new features view controller with images.

 @param imageNames The image's name array.
 @param rootVC     The key window's true root view controller.

 @return SRNewFeatureViewController
 */
+ (instancetype)newFeatureWithImageNames:(NSArray *)imageNames switchRootVCBtnImageName:(NSString *)imageName rootViewController:(UIViewController *)rootVC;

@end
