
#import "MainViewController.h"
#import "AudioTool.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController ()

@property (nonatomic, assign) SystemSoundID soundID;

@end

static BOOL isPlaying;

@implementation MainViewController

- (SystemSoundID)soundID {
    
    if (!_soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"buyao.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &_soundID);
    }
    return _soundID;
}

- (void)didReceiveMemoryWarning {
    
    [AudioTool disposeAudioWithFilename:@"buyao.wav"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //[self playSoundEffect:@"videoRing.caf"];
    
    // 播放本地音频
    //AudioServicesPlaySystemSound(self.soundID);
    
    // 同时播放多个音效
    //[AudioTool playAudioWithFilename:@"m_17.wav"];
    //[AudioTool playAudioWithFilename:@"buyao.wav"];
    
    // AudioServicesPlaySystemSound 也可以播放音乐, 但真实开发中不建议使用该函数播放音乐.
    //[AudioTool playAudioWithFilename:@"normal.aac"];
    
    [AudioTool playAudioWithFilename:[NSString stringWithFormat:@"m_%02d.wav", arc4random_uniform(15) + 3]];
}

#pragma mark - Play Audio File

/**
 播放音频文件

 @param fileName 音频文件名称
 */
- (void)playSoundEffect:(NSString *)fileName {
    
    if (isPlaying) {
        return;
    }
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID); // 此函数会将音频文件加入到系统音频服务中并返回一个长整形ID
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL); // 如果需要在播放完之后执行某些操作, 可以注册一个播放完成回调函数
    AudioServicesPlaySystemSound(soundID);  // 播放
    //AudioServicesPlayAlertSound(soundID); // 播放并震动
    isPlaying = YES;
}

/**
 回调函数

 @param soundID 系统声音 ID
 @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData)
{
    NSLog(@"播放完成");
    isPlaying = NO;
}

@end
