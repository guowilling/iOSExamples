//
//  UIImage+Clip.h
//  SRCategory
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)

- (instancetype)subImageInRect:(CGRect)rect;

- (instancetype)croppedImageAtFrame:(CGRect)frame;

@end
