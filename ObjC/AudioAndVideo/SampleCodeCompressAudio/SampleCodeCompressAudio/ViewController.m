//
//  ViewController.m
//  SampleCodeCompressAudio
//
//  Created by 郭伟林 on 2017/8/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAudioRecorder.h"
#import "SRAudioPlayer.h"
#import "SRAudioEditer.h"
#import "LameTool.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *audioPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.audioPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tempAudioFile.m4a"];
}

- (IBAction)record {
    
    [[SRAudioRecorder shareInstance] recordAudioToPath:self.audioPath];
}

- (IBAction)stop {
    
    [[SRAudioRecorder shareInstance] stop];
}

- (IBAction)compress {
    
    [LameTool compressAudioToMP3:self.audioPath deleteOriginalFile:NO];
}

- (IBAction)play {
    
    [[SRAudioPlayer shareInstance] playAudioWithPath:[self.audioPath stringByReplacingOccurrencesOfString:@".m4a" withString:@".mp3"]];
}

@end
