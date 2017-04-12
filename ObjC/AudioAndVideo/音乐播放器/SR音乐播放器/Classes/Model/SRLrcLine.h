//
//  LrcLine.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/28.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRLrcLine : NSObject

/** 时间点 */
@property (nonatomic, copy) NSString *time;

/** 歌词 */
@property (nonatomic, copy) NSString *word;

@end
