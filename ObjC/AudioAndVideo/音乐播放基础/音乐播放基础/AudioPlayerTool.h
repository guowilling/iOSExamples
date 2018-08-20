
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerTool : NSObject

+ (void)playAudioWithFilename:(NSString *)filename;
+ (void)destroyAudioWithFilename:(NSString *)filename;

+ (AVAudioPlayer *)playMusicWithFilename:(NSString *)filename;
+ (void)pauseMusicWithFilename:(NSString *)filename;
+ (void)stopMusicWithFilename:(NSString *)filename;

@end
