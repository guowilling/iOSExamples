//
//  SRAudioEditer.h
//  SampleCodeEditAudio
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRAudioEditer : NSObject

+ (void)combineAudio:(NSString *)audioPath toAudio:(NSString *)toAudioPath outputLoaction:(NSString *)outputPath;

+ (void)cutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputLoaction:(NSString *)outputPath;

@end
