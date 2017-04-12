
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface ShaderOperations : NSObject

+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment;

@end
