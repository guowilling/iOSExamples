//
//  UploadProgressView.h
//  UploadProgressViewDemo
//
//  Created by 郭伟林 on 16/8/27.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProgressType) {
    ProgressTypeBall,
    ProgressTypeWave
};

@interface UploadProgressView : UIView

@property (nonatomic, assign) ProgressType type;

@property (nonatomic, assign) CGFloat progress;

@end
