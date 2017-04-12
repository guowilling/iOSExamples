//
//  SRLrcView.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/28.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface SRLrcView : DRNRealTimeBlurView

@property (nonatomic, copy) NSString *lrcname;

@property (nonatomic, assign) NSTimeInterval currentTime;

@end
