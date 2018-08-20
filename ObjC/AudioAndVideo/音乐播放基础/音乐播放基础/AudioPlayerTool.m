
#import "AudioPlayerTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

@implementation AudioPlayerTool

+ (NSMutableDictionary *)soundIDs {
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}

+ (NSMutableDictionary *)players {
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

+ (void)playAudioWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) {
            return;
        }
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        self.soundIDs[filename] = @(soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}

+ (void)destroyAudioWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [self.soundIDs removeObjectForKey:filename];
    }
}

+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename {
    if (!filename) {
        return nil;
    }
    AVAudioPlayer *player = self.players[filename];
    if (!player) {
        NSLog(@"创建新的播放器");
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) {
            return nil;
        }
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        if(![player prepareToPlay]) {
            return nil;
        }
        self.players[filename] = player;
    }
    if (!player.playing) {
        [player play];
    }
    return player;
}

+ (void)pauseMusicWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    AVAudioPlayer *player = self.players[filename];
    if(player) {
        if (player.playing) {
            [player pause];
        }
    }
}

+ (void)stopMusicWithFilename:(NSString *)filename {
    if (!filename) {
        return;
    }
    AVAudioPlayer *player = self.players[filename];
    if (player) {
        [player stop];
        [self.players removeObjectForKey:filename];
    }
}

@end
