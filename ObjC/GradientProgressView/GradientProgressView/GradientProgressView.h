//
//  GradientProgressView.h
//  GradientProgressView
//
//  Created by Nick Jensen on 11/22/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientProgressView : UIView

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (nonatomic, assign) CGFloat progress;

- (void)startAnimating;

- (void)stopAnimating;

@end
