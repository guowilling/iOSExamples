
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerTool.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *musics;

@property (nonatomic, assign) int currentIndex;

@end

@implementation ViewController

- (NSArray *)musics {
    
    if (!_musics) {
        _musics = @[@"傻子.mp3", @"心酸.mp3", @"拥有.mp3", @"突然想起你.mp3",@"越反越爱.mp3"];
    }
    return _musics;
}

- (IBAction)playMusic:(id)sender {
    
    [AudioPlayerTool playMusicWithFilename:self.musics[self.currentIndex]];
}

- (IBAction)pauseMusic:(id)sender {
    
    [AudioPlayerTool pauseMusicWithFilename:self.musics[self.currentIndex]];
}

- (IBAction)stopMusic:(id)sender {
    
    [AudioPlayerTool stopMusicWithFilename:self.musics[self.currentIndex]];
}

- (IBAction)nextMusic:(id)sender {
    
    [self stopMusic:nil]; // 停止上一首
    int nextIndex = self.currentIndex + 1;
    self.currentIndex = nextIndex >= self.musics.count ? 0 : nextIndex;
    [self playMusic:nil]; // 播放下一首
}

@end
