
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVAudioRecorderDelegate>

@property (nonatomic,strong) AVAudioRecorder *audioRecorder; // 音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer; // 音频播放器
@property (nonatomic,strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIButton *record; // 开始录音
@property (weak, nonatomic) IBOutlet UIButton *pause;  // 暂停录音
@property (weak, nonatomic) IBOutlet UIButton *resume; // 恢复录音
@property (weak, nonatomic) IBOutlet UIButton *stop;   // 停止录音

@property (weak, nonatomic) IBOutlet UIProgressView *audioPower; // 音频波动

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 设置音频会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (NSURL *)getSavePath {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myRecord.caf"];
    NSLog(@"path: %@", path);
    return [NSURL fileURLWithPath:path];
}

- (NSDictionary *)getAudioSetting {
    
    NSMutableDictionary *audioSetting = [NSMutableDictionary dictionary];
    [audioSetting setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey]; // 录音格式
    [audioSetting setObject:@(8000) forKey:AVSampleRateKey]; // 录音采样率
    [audioSetting setObject:@(1) forKey:AVNumberOfChannelsKey]; // 设置通道
    [audioSetting setObject:@(8) forKey:AVLinearPCMBitDepthKey]; // 每个采样点位数
    [audioSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey]; // 是否使用浮点数采样
    return audioSetting;
}

- (AVAudioRecorder *)audioRecorder {
    
    if (!_audioRecorder) {
        NSError *error;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath] settings:[self getAudioSetting] error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
        if (error) {
            NSLog(@"初始化 AVAudioRecorder 失败: %@", error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

-(AVAudioPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[self getSavePath] error:&error];
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"初始化 AVAudioPlayer 失败: %@", error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

- (NSTimer *)timer {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(audioPowerDidChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)audioPowerDidChange {
    
    [self.audioRecorder updateMeters];
    float power = [self.audioRecorder averagePowerForChannel:0]; // 声波
    if (power <= -20) {
        [self performSelector:@selector(stopClick:) withObject:nil afterDelay:2.0];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    CGFloat progress = (1.0 / 160.0) * (power + 160.0); // 音频强度范围是 -160 到 0
    [self.audioPower setProgress:progress];
}

- (IBAction)recordClick:(UIButton *)sender {
    
    if ([self.audioRecorder isRecording]) {
        return;
    }
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record]; // 首次调用会自动请求用户授权麦克风
    self.timer.fireDate = [NSDate distantPast];
}

- (IBAction)pauseClick:(UIButton *)sender {
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (IBAction)resumeClick:(UIButton *)sender {
    
    [self recordClick:sender]; // 恢复录音只需要再次调用 record, AVAudioSession 会自动记录上次录音位置并追加录音.
}

- (IBAction)stopClick:(UIButton *)sender {
    
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
    self.audioPower.progress = 0.0;
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    if (flag) {
        NSLog(@"录音成功");
        if (![self.audioPlayer isPlaying]) {
            [self.audioPlayer play];
        }
    } else {
        NSLog(@"录音失败");
    }
}

@end
