//
//  SRAudioTool.h
//  SR音乐播放器
//
//  Created by 郭伟林 on 15/10/27.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SRAudioTool : NSObject

#pragma mark - Auido

/**
 播放音效

 @param filename 音效文件名
 */
+ (void)playAudioWithFilename:(NSString  *)filename;

/**
 销毁音效

 @param filename 音效文件名
 */
+ (void)disposeAudioWithFilename:(NSString  *)filename;

#pragma mark - Music

/**
 播放音乐

 @param filename 音乐文件名
 @return 音乐播放器
 */
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;

/**
 暂停音乐

 @param filename 音乐文件名
 */
+ (void)pauseMusicWithFilename:(NSString  *)filename;

/**
 停止音乐

 @param filename 音乐文件名
 */
+ (void)stopMusicWithFilename:(NSString  *)filename;

@end
