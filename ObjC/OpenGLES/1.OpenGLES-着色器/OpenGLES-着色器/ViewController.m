//
//  ViewController.m
//  OpenGLES-着色器
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
    GLuint _colorSlot; // 用于绑定 shader 中的 SourceColor 参数
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupGLContext];
    
    [self setupCAEAGLLayer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f); // 清屏颜色, Blue.
    
    glClear(GL_COLOR_BUFFER_BIT); // 指定要用清屏颜色来清除的 buffer.
    
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _glProgram = [ShaderOperations compileShaders:@"DemoShaderVertex" shaderFragment:@"DemoShaderFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _colorSlot = glGetAttribLocation(_glProgram, "SourceColor");
    
    [self render];
}

- (void)render {
    
    // 直接使用顶点数组
//    [self renderVertices];
    
    // 使用顶点索引数组
//    [self renderUsingIndex];
    
    // 使用 VBO
//    [self renderUsingVBO];
    
    // 使用索引数组 + VBO
    [self renderUsingIndexVBO];
    
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

#pragma mark - 直接使用顶点数组

- (void)renderVertices {
    
    [self renderVertices_triangles];
    //[self renderVertices_triangle_strip];
    //[self renderVertices_triangle_fan];
}

- (void)renderVertices_triangles {
    
    // 顶点数组
    const GLfloat Vertices[] = {
        -1,-1,0, // 左下，黑色
        1,-1,0,  // 右下，红色
        -1,1,0,  // 左上，蓝色
        
        1,-1,0,  // 右下，红色
        -1,1,0,  // 左上，蓝色
        1,1,0,   // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    // 纯粹使用顶点的方式, 颜色与顶点要一一对应.
    
    // shader 中 DestinationColor 为最终要传递给 OpenGLES 的颜色.
    // 要使用 varying 即两个顶点之间颜色平滑渐变.
    // 如果不使用 varying 则完全花掉.
    
    // 取出 Vertices 数组中值赋给 _positionSlot.
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 取出 Colors 数组中的值赋给 _colorSlot.
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制两个三角形, 不复用顶点, 需要6个顶点坐标.
    // V0-V1-V2
    // V3-V4-V5
    
    // 参数1: 三角形组合方式.
    // 参数2: 从顶点数组的哪个 offset 开始.
    // 参数3: 顶点个数.
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)renderVertices_triangle_strip {
    
    const GLfloat Vertices[] = {
        -1,-1,0, // 左下，黑色
        1,-1,0,  // 右下，红色
        -1,1,0,  // 左上，蓝色
        1,1,0,   // 右上，绿色
    };
    
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制两个三角形，复用两个顶点，因此只需要四个顶点坐标.
    // V0-V1-V2
    // V1-V2-V3
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)renderVertices_triangle_fan {

    const GLfloat Vertices[] = {
        -1,1,0, // 左上，蓝色
        -1,-1,0,// 左下，黑色
        1,-1,0, // 右下，红色
        1,1,0,  // 右上，绿色
    };
    
    const GLfloat Colors[] = {
        0,0,1,1, // 左上，蓝色
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,1,0,1, // 右上，绿色
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    
    // 绘制两个三角形，复用两个顶点，因此只需要四个顶点坐标.
    // V0-V1-V2
    // V0-V2-V3
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

#pragma mark - 使用顶点索引数组

- (void)renderUsingIndex {
    
    // 顶点数组
    const GLfloat Vertices[] = {
        -1,-1,0, // 左下，黑色
        1,-1,0,  // 右下，红色
        -1,1,0,  // 左上，蓝色
        1,1,0,   // 右上，绿色
    };
    
    // 颜色数组
    const GLfloat Colors[] = {
        0,0,0,1, // 左下，黑色
        1,0,0,1, // 右下，红色
        0,0,1,1, // 左上，蓝色
        0,1,0,1, // 右上，绿色
    };
    
    // 索引数组指定绘制三角形的方式与 glDrawArrays(GL_TRIANGLE_STRIP, 0, 4) 一样.
    const GLubyte Indices[] = {
        0,1,2, // 三角形 0
        1,2,3  // 三角形 1
    };
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, Vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 0, Colors);
    glEnableVertexAttribArray(_colorSlot);
    // 注意: 未使用 VBO 时, glVertexAttribPointer 的最后一个参数是指向对应数组的指针.
    
    /**
     *  参数1: 三角形组合方式
     *  参数2: 索引数组中的元素个数, 即6个元素才能绘制矩形
     *  参数3: 索引数组中的元素类型
     *  参数4: 索引数组
     */
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, Indices);
    // 注意: 未使用 VBO 时, glDrawElements 的最后一个参数是指向对应索引数组的指针.
    
    // 结论: 不管使用哪种方式顶点和颜色两个数组一定要一一对应.
    // glDrawArrays:
    // glDrawElements: 引入了索引则很方便地实现顶点的复用, 使用顶点索引数组可减少存储和绘制重复顶点的资源消耗.
}

#pragma mark - 使用 VBO

- (void)renderUsingVBO {
    
    // Vertex Buffer Object
    
    // 定义 Vertex 结构包含坐标和颜色数组
    typedef struct {
        float Position[3];
        float Color[4];
    } Vertex;
    
    // 顶点数组
    const Vertex Vertices[] = {
        {{-1,-1,0}, {0,0,0,1}}, // 左下，黑色
        {{1,-1,0}, {1,0,0,1}},  // 右下，红色
        {{-1,1,0}, {0,0,1,1}},  // 左上，蓝色
        {{1,1,0}, {0,1,0,1}},   // 右上，绿色
    };
    
    GLuint vertexBuffer; // GL_ARRAY_BUFFER 用于顶点数组
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer); // 绑定 vertexBuffer 到 GL_ARRAY_BUFFER
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW); // 传递数据到 VBO
    
    // 注意:
    // 未使用 VBO 时, glVertexAttribPointer 的最后一个参数是指向对应数组的指针.
    // 当使用 VBO 时, glVertexAttribPointer 的最后一个参数是要获取的参数在 GL_ARRAY_BUFFER(每个 Vertex)的偏移量
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    
    // Vertex 结构体偏移3个 float 的位置即是 Color 值
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    
    // 使用 glDrawArrays 也可绘制, 此时仅从 GL_ARRAY_BUFFER 中取出顶点数据.
    // 索引数组就可以不要了即 GL_ELEMENT_ARRAY_BUFFER 实际上没有用到.
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

#pragma mark - 使用索引数组 + VBO

- (void)renderUsingIndexVBO {
    
    typedef struct {
        float Position[3];
        float Color[4];
    } Vertex;
    
    // 顶点数组
    const Vertex Vertices[] = {
        {{-1,-1,0}, {0,0,0,1}}, // 左下，黑色
        {{1,-1,0}, {1,0,0,1}},  // 右下，红色
        {{-1,1,0}, {0,0,1,1}},  // 左上，蓝色
        {{1,1,0}, {0,1,0,1}},   // 右上，绿色
    };
    
    // 索引数组
    const GLubyte Indices[] = {
        0,1,2, // 三角形 0
        1,2,3  // 三角形 1
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    // GL_ELEMENT_ARRAY_BUFFER 用于顶点数组对应的 Indices 即索引数组
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    
    // 使用 glDrawArrays 也可绘制, 此时仅从 GL_ARRAY_BUFFER 中取出顶点数据.
    // 索引数组就可以不要了即 GL_ELEMENT_ARRAY_BUFFER 实际上没有用到.
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // 使用 glDrawElements 的方式本身就用到了索引即 GL_ELEMENT_ARRAY_BUFFER, 所以 GL_ARRAY_BUFFER 和 GL_ELEMENT_ARRAY_BUFFER 两个都需要.
    
    /**
     *  参数1: 三角形组合方式
     *  参数2: 索引数组中的元素个数, 即6个元素才能绘制矩形
     *  参数3: 索引数组中的元素类型
     *  参数4: 索引数组在 GL_ELEMENT_ARRAY_BUFFER(索引数组)中的偏移量
     */
    
    // 注意:
    // 未使用 VBO 时, glDrawElements 的最后一个参数是指向对应索引数组的指针.
    // 当使用 VBO 时, 参数4表示索引数据在 VBO(GL_ELEMENT_ARRAY_BUFFER)中的偏移量.
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

@end
