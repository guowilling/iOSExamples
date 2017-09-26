//
//  ViewController.m
//  SampleCodeEditAudio
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAudioRecorder.h"
#import "SRAudioPlayer.h"
#import "SRAudioEditer.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *audioPath1;
@property (nonatomic, copy) NSString *audioPath2;
@property (nonatomic, copy) NSString *audioPath3;
@property (nonatomic, copy) NSString *audioPath4;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.audioPath1 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordAudioFile1.m4a"];
    self.audioPath2 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordAudioFile2.m4a"];
    self.audioPath3 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordAudioFile3.m4a"];
    self.audioPath4 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordAudioFile4.m4a"];
}

- (IBAction)record {
    
    //[[SRAudioRecorder shareInstance] recordAudioToPath:self.audioPath1];
    
    [[SRAudioRecorder shareInstance] recordAudioToPath:self.audioPath2];
}

- (IBAction)stop {
    
    [[SRAudioRecorder shareInstance] stop];
}

- (IBAction)combine {
    
    [SRAudioEditer combineAudio:self.audioPath1 toAudio:self.audioPath2 outputLoaction:self.audioPath3];
}

- (IBAction)crop {
    
    [SRAudioEditer cutAudio:self.audioPath3 fromTime:2 toTime:5 outputLoaction:self.audioPath4];
}

- (IBAction)play {
    
    //[[SRAudioPlayer shareInstance] playAudioWithPath:self.audioPath3];
    
    [[SRAudioPlayer shareInstance] playAudioWithPath:self.audioPath4];
}

@end
