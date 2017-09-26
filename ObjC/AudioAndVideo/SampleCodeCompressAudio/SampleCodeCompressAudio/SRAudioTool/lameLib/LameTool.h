
#import <Foundation/Foundation.h>

@interface LameTool : NSObject

+ (NSString *)compressAudioToMP3:(NSString *)originalAudioPath deleteOriginalFile:(BOOL)isDelete;

@end
