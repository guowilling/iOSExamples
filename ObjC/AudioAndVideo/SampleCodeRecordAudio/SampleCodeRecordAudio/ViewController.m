//
//  ViewController.m
//  SampleCodeRecordAudio
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAudioRecorder.h"
#import "SRAudioPlayer.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *audioPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.audioPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordAudioFile.m4a"];
}

- (IBAction)record {
    
    [[SRAudioRecorder shareInstance] recordAudioToPath:self.audioPath];
}

- (IBAction)pause {
    
    [[SRAudioRecorder shareInstance] pause];
}

- (IBAction)resume {
    
    [[SRAudioRecorder shareInstance] resume];
}

- (IBAction)stop {
    
    [[SRAudioRecorder shareInstance] stop];
}

- (IBAction)reRecord {
    
    [[SRAudioRecorder shareInstance] reRecord];
}

- (IBAction)delete {
    
    [[SRAudioRecorder shareInstance] deleteRecording];
}

- (IBAction)play {

    [[SRAudioPlayer shareInstance] playAudioWithPath:self.audioPath];
}

@end
