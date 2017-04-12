//
//  ViewController.m
//  OpenGLES-简单图形绘制
//
//  Created by 郭伟林 on 17/4/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "ShaderOperations.h"
#import <OpenGLES/ES2/gl.h>

@interface ViewController () {
    
    // An EAGLContext object manages an OpenGL ES rendering context—the state information, commands, and resources needed to draw using OpenGL ES. To execute OpenGL ES commands, you need a current rendering context.
    EAGLContext *_GLContext;
    
    // A layer that supports drawing OpenGL content in iOS and tvOS applications.
    CAEAGLLayer *_GLLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
    
    GLuint _glProgram;
    GLuint _positionSlot; // 用于绑定 shader 中的 Position 参数
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupGLContext];
    
    [self setupCAEAGLLayer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // 清屏颜色, Blue.
    
    glClear(GL_COLOR_BUFFER_BIT); // 指定要用清屏颜色来清除的 buffer.
    
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _glProgram = [ShaderOperations compileShaders:@"DemoTriangleVertex" shaderFragment:@"DemoTriangleFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    
    [self render];
    
    UIImage *image = [self getResultImage];
    
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 200) * 0.5,
                                                                               CGRectGetHeight(self.view.frame) - 100,
                                                                               200, 100)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        [self.view addSubview:imageView];
    }
}

- (void)render {
    
//    [self renderVertices];
//    [self renderUsingIndex];
//    [self renderUsingVBO];
    [self renderUsingIndexVBO];
    
    [_GLContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupGLContext {
    
    // Initializes and returns a newly allocated rendering context with the specified version of the OpenGL ES rendering API.
    _GLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Makes the specified context the current rendering context for the calling thread.
    [EAGLContext setCurrentContext:_GLContext];
}

- (void)setupCAEAGLLayer {
    
    _GLLayer = [CAEAGLLayer layer];
    _GLLayer.frame = self.view.frame;
    _GLLayer.opaque = YES; // The default value of this property is NO
    
    // kEAGLDrawablePropertyRetainedBacking:
    // 若为 YES, 使用 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) 计算得到的最终结果颜色透明度会考虑目标颜色的透明度.
    // 若为 NO, 则不考虑目标颜色的透明度, 当做不透明来处理.
    
    // 使用场景: 目标颜色为不透明, 源颜色有透明度.
    // 若为 YES, 则使用 glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) 得到的结果颜色会有一定的透明度(与实际不符).
    // 若为 NO, 则不会(符合实际).
    _GLLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: [NSNumber numberWithBool:NO],
                                    kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    [self.view.layer addSublayer:_GLLayer];
}

- (void)setupRenderBuffer {
    
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    // 生成一个 renderBuffer, id 是 _colorRenderBuffer.
    glGenRenderbuffers(1, &_colorRenderBuffer);
    
    // 绑定 renderBuffer, 后面引用 GL_RENDERBUFFER 即是 _colorRenderBuffer.
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    // Binds a drawable object’s storage to an OpenGL ES renderbuffer object.
    [_GLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_GLLayer];
}

- (void)setupFrameBuffer {
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    glGenFramebuffers(1, &_frameBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    // _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)renderVertices {
    
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    
    // Load the vertex data
    // 不使用 VBO, 则直接从 CPU 传递顶点数据到 GPU 进行渲染.
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw triangle
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)renderUsingIndex {
    
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    
    const GLubyte indices[] = {
        0,1,2
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);
}

- (void)renderUsingVBO {
    
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)renderUsingIndexVBO {
    const GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    
    const GLubyte indices[] = {
        0,1,2
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer); // 绑定 vertexBuffer 到 GL_ARRAY_BUFFER
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW); // 初始化并传递数据, 申请空间.
    
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0); // 最后一个参数为要获取参数在 GL_ARRAY_BUFFER中 的偏移量
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (UIImage *)getResultImage {
    
    CGSize currentFBOSize = self.view.frame.size;
    NSUInteger totalBytesForImage = (int)currentFBOSize.width * (int)currentFBOSize.height * 4;
    
    GLubyte *_rawImagePixelsTemp = (GLubyte *)malloc(totalBytesForImage);
    
    glReadPixels(0, 0, (int)currentFBOSize.width, (int)currentFBOSize.height, GL_RGBA, GL_UNSIGNED_BYTE, _rawImagePixelsTemp);
    glUseProgram(0);
    
    // 图像经过 render 之后已经在 FBO中 了, 即使不将其拿到 RenderBuffer 中依然可以使用 getResultImage 取到图像数据.
    // [_eaglContext presentRenderbuffer:GL_RENDERBUFFER] 实际上就是将 FBO 中的图像拿到 RenderBuffer 中即屏幕上.
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, _rawImagePixelsTemp, totalBytesForImage, (CGDataProviderReleaseDataCallback)&freeData);
    CGColorSpaceRef defaultRGBColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef cgImageFromBytes = CGImageCreate((int)currentFBOSize.width, (int)currentFBOSize.height, 8, 32, 4 * (int)currentFBOSize.width, defaultRGBColorSpace, kCGBitmapByteOrderDefault, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:cgImageFromBytes scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease(cgImageFromBytes);
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(defaultRGBColorSpace);
    
    return finalImage;
}

void freeData(void *info, const void *data, size_t size)
{
    free((unsigned char *)data);
}

@end
