//
//  SRAudioRecorder.m
//  RecordAudioSImpleCode
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface SRAudioRecorder ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, copy) NSString *audioFilePath;

@end

@implementation SRAudioRecorder

SRSingletonImplement(SRAudioRecorder)

- (AVAudioRecorder *)recorder {
    
    if (!_recorder) {
        // 设置录音会话
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];

        // 设置录音参数
        NSMutableDictionary *recordSettings = [NSMutableDictionary dictionary];
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey]; // 编码格式
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey]; // 采样率
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey]; // 通道数
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey]; // 采样质量
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_audioFilePath]
                                                settings:recordSettings
                                                   error:nil];
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

- (void)recordAudioToPath:(NSString *)path {
    
    if (path) {
        _audioFilePath = path;
    }
    [self.recorder prepareToRecord];
    [self.recorder record];
}

- (void)pause {
    
    [self.recorder pause];
}

- (void)resume {
    
    [self.recorder record];
}

- (void)stop {
    
    [self.recorder stop];
}

- (void)reRecord {
    
    self.recorder = nil;
    [self recordAudioToPath:nil];
}

- (void)deleteRecording {
    
    [self stop];
    [self.recorder deleteRecording];
}

- (CGFloat)peakPowerForChannel0 {
    
    [self updateMeters];
    
    return [self.recorder peakPowerForChannel:0];
}

- (void)updateMeters {
    
    [self.recorder updateMeters];
}

@end
