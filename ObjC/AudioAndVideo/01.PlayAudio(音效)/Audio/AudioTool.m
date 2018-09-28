
#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioTool

static NSMutableDictionary *_soundIDs;

+ (void)initialize {
    _soundIDs = [NSMutableDictionary dictionary];
}

+ (void)playAudioWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    SystemSoundID soundID = [_soundIDs[filename] unsignedIntValue];
    if (soundID) {
        AudioServicesPlaySystemSound(soundID);
    } else {
        NSLog(@"创建新的 soundID");
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) {
            return;
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [_soundIDs setObject:@(soundID) forKey:filename];
    }
}

+ (void)disposeAudioWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    SystemSoundID soundID = [_soundIDs[filename] unsignedIntValue];
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [_soundIDs removeObjectForKey:filename];
    }
}

@end
