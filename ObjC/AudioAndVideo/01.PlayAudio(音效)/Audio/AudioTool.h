
#import <Foundation/Foundation.h>

@interface AudioTool : NSObject

+ (void)playAudioWithFilename:(NSString *)filename;

+ (void)disposeAudioWithFilename:(NSString *)filename;

@end
