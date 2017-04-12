//
//  OpenGLESDrawImageView.m
//  OpenGLES-图片纹理
//
//  Created by 郭伟林 on 17/4/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "OpenGLESDrawImageView.h"
#import "ShaderOperations.h"
#import <OpenGLES/ES2/gl.h>

@interface OpenGLESDrawImageView () {
    
    EAGLContext *_eaglContext;
    
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLuint _glProgram;
    GLuint _positionSlot;
    GLuint _textureSlot;
    GLuint _textureCoordsSlot;
    GLuint _textureID;
}

@end

@implementation OpenGLESDrawImageView

+ (Class)layerClass {
    
    return [CAEAGLLayer class];
}

- (void)drawRect:(CGRect)rect {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOpenGLES];
        [self drawImageViaOpenGLES:[UIImage imageNamed:@"TestImage.jpg"]];
    }
    return self;
}

- (void)setupOpenGLES {
    
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eaglContext];
    
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
    
    _glProgram = [ShaderOperations compileShaders:@"DemoDrawImageTextureVertex" shaderFragment:@"DemoDrawImageTextureFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _textureSlot = glGetUniformLocation(_glProgram, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_glProgram, "TextureCoords");
}

#pragma mark - didDrawImageViaOpenGLES

- (void)drawImageViaOpenGLES:(UIImage *)image {

    _textureID = [self textureOfImage:image];

    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glUniform1i(_textureSlot, 5);
    
    [self render];
    
    glBindTexture(GL_TEXTURE_2D, 0);
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - setupTexture

- (GLuint)textureOfImage:(UIImage *)image {
    
    CGImageRef cgImageRef = [image CGImage];
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImageRef);
    
    glEnable(GL_TEXTURE_2D);

    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

    glBindTexture(GL_TEXTURE_2D, 0);
    CGContextRelease(context);
    free(imageData);
    
    return textureID;
}

#pragma mark - render

- (void)render {
    
    //  [self renderVertices];
    //  [self renderUsingIndex];
    //  [self renderUsingVBO];
    [self renderUsingIndexVBO];
}

- (void)renderVertices {
    
    GLfloat texCoords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1,
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    GLfloat vertices[] = {
        -1, -1, 0,
        1,  -1, 0,
        -1, 1,  0,
        1,  1,  0
    };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)renderUsingIndex {
    
    const GLfloat texCoords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1,
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0,
        1,  -1, 0,
        -1, 1,  0,
        1,  1,  0
    };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    const GLubyte indices[] = {
        0,1,2,
        1,2,3
    };
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);
}

- (void)renderUsingVBO {
    
    const GLfloat texCoords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1,
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0,
        1,  -1, 0,
        -1, 1,  0,
        1,  1,  0
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(_positionSlot);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)renderUsingIndexVBO {
    
    const GLfloat texCoords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1,
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0,
        1,  -1, 0,
        -1, 1,  0,
        1,  1,  0
    };
    
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(_positionSlot);
    
    const GLubyte indices[] = {
        0,1,2,
        1,2,3
    };
    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
}

@end
