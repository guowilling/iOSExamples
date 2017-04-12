//
//  SRMusicTool.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRMusic.h"

@interface SRMusicTool : NSObject

/** 获取所有音乐 */
+ (NSArray *)musics;

/** 设置当前正在播放的音乐 */
+ (void)setPlayingMusic:(SRMusic *)music;

/** 返回当前正在播放的音乐 */
+ (SRMusic *)playingMusic;

/** 返回下一首 */
+ (SRMusic *)nextMusic;

/** 返回上一首 */
+ (SRMusic *)previouesMusic;

@end
