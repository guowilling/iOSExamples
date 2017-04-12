//
//  ViewController.m
//  OpenGLES-初步认识
//
//  Created by 郭伟林 on 17/4/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES2/gl.h>

@interface ViewController () {
    
    // An EAGLContext object manages an OpenGL ES rendering context—the state information, commands, and resources needed to draw using OpenGL ES. To execute OpenGL ES commands, you need a current rendering context.
    EAGLContext *_GLContext;
    
    // A layer that supports drawing OpenGL content in iOS and tvOS applications.
    CAEAGLLayer *_GLLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupGLContext];
    
    [self setupCAEAGLLayer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    [self render];
}

- (void)render {
    
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f); // 清屏颜色, Blue.
    glClear(GL_COLOR_BUFFER_BIT); // 指定要用清屏颜色来清除的 buffer.
    
    // Displays a renderbuffer’s contents on screen.
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

@end
