//
//  SRAudioRecorder.h
//  RecordAudioSImpleCode
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSingleton.h"

@interface SRAudioRecorder : NSObject

SRSingletonInterface

- (void)recordAudioToPath:(NSString *)path;

- (void)pause;

- (void)resume;

- (void)stop;

- (void)reRecord;

- (void)deleteRecording;

@end
