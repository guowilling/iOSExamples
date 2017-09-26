//
//  SRAudioEditer.m
//  SampleCodeEditAudio
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioEditer.h"
#import <AVFoundation/AVFoundation.h>

@implementation SRAudioEditer

+ (void)combineAudio:(NSString *)audioPath toAudio:(NSString *)toAudioPath outputLoaction:(NSString *)outputPath {
    
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    AVURLAsset *asset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:toAudioPath]];
    
    AVAssetTrack *track1 = [asset1 tracksWithMediaType:AVMediaTypeAudio].firstObject;
    AVAssetTrack *track2 = [asset2 tracksWithMediaType:AVMediaTypeAudio].firstObject;
    
    AVMutableComposition *compostion = [AVMutableComposition composition];
    AVMutableCompositionTrack *compostionTrack = [compostion addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    [compostionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:track2 atTime:kCMTimeZero error:nil];
    [compostionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset1.duration) ofTrack:track1 atTime:asset2.duration error:nil];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:compostion presetName:AVAssetExportPresetAppleM4A];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = exportSession.status;
        if (status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
        }
    }];
}

+ (void)cutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputLoaction:(NSString *)outputPath {
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    
    CMTime startTime = CMTimeMake(fromTime, 1);
    CMTime endTime = CMTimeMake(toTime, 1);
    exportSession.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = exportSession.status;
        if (status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
        }
    }];
}

@end
