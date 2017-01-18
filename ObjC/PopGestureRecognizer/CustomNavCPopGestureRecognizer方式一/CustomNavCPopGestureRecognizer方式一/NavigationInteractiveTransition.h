//
//  NavigationInteractiveTransition.h
//  UIScreenEdgePanGestureRecognizer
//
//  Created by Jazys on 15/3/30.
//  Copyright (c) 2015年 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationInteractiveTransition : NSObject 

- (instancetype)initWithNavigationController:(UINavigationController *)navC;

- (void)handlePanGuetureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
