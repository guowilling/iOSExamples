//
//  SRMusic.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRMusic : NSObject

/** 歌曲名字 */
@property (copy, nonatomic) NSString *name;

/** 歌曲图片 */
@property (copy, nonatomic) NSString *icon;

/** 歌曲的文件名 */
@property (copy, nonatomic) NSString *filename;

/** 歌词的文件名 */
@property (copy, nonatomic) NSString *lrcname;

/** 歌手名称 */
@property (copy, nonatomic) NSString *singer;

/** 歌手图标 */
@property (copy, nonatomic) NSString *singerIcon;

@end
