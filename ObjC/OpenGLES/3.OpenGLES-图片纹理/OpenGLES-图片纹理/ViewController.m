//
//  ViewController.m
//  OpenGLES-图片纹理
//
//  Created by 郭伟林 on 17/4/11.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLESDrawImageView.h"
#import "ShaderOperations.h"
#import <OpenGLES/ES2/gl.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    // An EAGLContext object manages an OpenGL ES rendering context—the state information, commands, and resources needed to draw using OpenGL ES. To execute OpenGL ES commands, you need a current rendering context.
    EAGLContext *_GLContext;
    
    // A layer that supports drawing OpenGL content in iOS and tvOS applications.
    CAEAGLLayer *_GLLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
    
    GLuint _glProgram;
    GLuint _positionSlot; // 顶点
    GLuint _textureSlot; // 纹理
    GLuint _textureCoordsSlot; // 纹理坐标
    GLuint _textureID; // 纹理ID
    
    CGRect _CAEAGLLayerFrame;
}

@property (nonatomic, strong) UIImage     *originalImage;
@property (nonatomic, strong) UIImageView *originalImageView;

@property (nonatomic, strong) OpenGLESDrawImageView *drawImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self displayOriginImage];
    
    _CAEAGLLayerFrame = CGRectMake(10, 350, self.view.frame.size.width - 20, 200);
    
    [self setupOpenGLES];
    
    //[self drawImageViaOpenGLES:_originalImage];
    
    _drawImageView = [[OpenGLESDrawImageView alloc] initWithFrame:_CAEAGLLayerFrame];
    [self.view addSubview:_drawImageView];
}

- (void)drawImageViaOpenGLES:(UIImage *)image {
    
    // 绑定 image 到 GL_TEXTURE_2D 上即传递到 GPU.
    _textureID = [self textureOfImage:image];
    
    // 此时纹理数据就可看做已经在纹理对象 _textureID 中了, 使用时从中取出即可.
    
    glActiveTexture(GL_TEXTURE5); // 指定纹理单元 GL_TEXTURE5(默认使用 GL_TEXTURE0 作为当前激活的纹理单元).
    glBindTexture(GL_TEXTURE_2D, _textureID); // 绑定即可从 _textureID 中取出图像数据.
    glUniform1i(_textureSlot, 5); // 与纹理单元的序号对应.
    
    // 渲染需要的数据要从 GL_TEXTURE_2D 中得到, GL_TEXTURE_2D 与 _textureID 已经绑定.
    [self render];
    
    glBindTexture(GL_TEXTURE_2D, 0);
    [_GLContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupOpenGLES {
    
    [self setupGLContext];
    
    [self setupCAEAGLLayer];
    
    [self setupRenderBuffer];
    
    [self setupFrameBuffer];
    
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, CGRectGetWidth(_CAEAGLLayerFrame), CGRectGetHeight(_CAEAGLLayerFrame));
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
    
    _glProgram = [ShaderOperations compileShaders:@"DemoDrawImageTextureVertex" shaderFragment:@"DemoDrawImageTextureFragment"];
    glUseProgram(_glProgram);
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _textureSlot = glGetUniformLocation(_glProgram, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_glProgram, "TextureCoords");
}

- (void)displayOriginImage {
    
    UILabel *lbOriginalImage = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width - 20, 30)];
    lbOriginalImage.text = @"Click image to choose from local photos...";
    lbOriginalImage.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbOriginalImage];
    
    _originalImage = [UIImage imageNamed:@"TestImage.jpg"];
    _originalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 200)];
    _originalImageView.image = _originalImage;
    _originalImageView.userInteractionEnabled = YES;
    [self.view addSubview:_originalImageView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageFromPhotoLibrary)];
    [_originalImageView addGestureRecognizer:tapGestureRecognizer];
    
    UILabel *lbProcessedImage = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, self.view.frame.size.width - 20, 30)];
    lbProcessedImage.text = @"Processed image...";
    lbProcessedImage.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbProcessedImage];
}

- (void)imageFromPhotoLibrary {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)setupGLContext {
    
    // Initializes and returns a newly allocated rendering context with the specified version of the OpenGL ES rendering API.
    _GLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Makes the specified context the current rendering context for the calling thread.
    [EAGLContext setCurrentContext:_GLContext];
}

- (void)setupCAEAGLLayer {
    
    _GLLayer = [CAEAGLLayer layer];
    _GLLayer.frame = _CAEAGLLayerFrame;
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    UIImage *image = editedImage ? editedImage : originalImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        _originalImage = image;
        _originalImageView.image = image;
        [self drawImageViaOpenGLES:image];
        [_drawImageView drawImageViaOpenGLES:image];
    }];
}

#pragma mark - setupTexture

/**
 *  1.使用 CoreGraphics 将位图以 RGBA 格式存放, 将 UIImage 图像数据转化成 OpenGL ES 接受的数据.
 *  2.然后在 GPU 中将图像纹理传递给 GL_TEXTURE_2D.
 *  3.return 返回的是纹理对象, 该纹理对象暂时未跟 GL_TEXTURE_2D 绑定(要调用bind).
 *  4.GL_TEXTURE_2D 中的图像数据都可从纹理对象中取出.
 */
- (GLuint)textureOfImage:(UIImage *)image {
    
    CGImageRef cgImageRef = image.CGImage;
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
    
    glEnable(GL_TEXTURE_2D); // GL_TEXTURE_2D 表示操作 2D 纹理
    
    GLuint textureID;
    glGenTextures(1, &textureID); // 创建纹理对象
    glBindTexture(GL_TEXTURE_2D, textureID); // 绑定纹理对象

    // 纹理过滤函数:
    // 图像从纹理图像空间映射到帧缓冲图像空间需要重新构造纹理图像, 会造成应用到多边形上的图像失真.
    // 可以通过 glTexParmeteri() 函数来确定如何把纹理像素映射成像素.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); // S 方向上的贴图模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE); // T 方向上的贴图模式
    
    // 线性过滤: 使用距离当前渲染像素中心最近的4个纹理像素加权平均值.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    // 图像数据传递给到 GL_TEXTURE_2D 中, 因其于已经与 textureID 纹理对象绑定, 所以即传递到 textureID 纹理对象中.
    // GL_TEXTURE_2D 会将图像数据从 CPU 内存通过 PCIE 上传到 GPU 内存.
    // 不使用 PBO 时它是一个阻塞 CPU 的函数, 数据量大的话会卡.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    glBindTexture(GL_TEXTURE_2D, 0); // 解绑
    CGContextRelease(context); // 释放
    free(imageData); // 释放
    
    return textureID;
}

#pragma mark - render

- (void)render {
    
//    [self renderVertices];
//    [self renderUsingIndex];
//    [self renderUsingVBO];
    [self renderUsingIndexVBO];
}

/**
 *  直接取出对应纹理坐标 TextureCoords
 *  根据顶点数据和纹理坐标数据(一一对应), 填充到对应的坐标位置 Positon 中.
 *  注意: 二者的坐标系不同.
 */
- (void)renderVertices {
    
    GLfloat texCoords[] = {
        0, 0, // 左下
        1, 0, // 右下
        0, 1, // 左上
        1, 1, // 右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    
    GLfloat vertices[] = {
        -1, -1, 0, // 左下
        1,  -1, 0, // 右下
        -1, 1,  0, // 左上
        1,  1,  0  // 右上
    };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 一旦纹理数据准备好, 两个坐标系的顶点位置一一对应好, 就直接绘制顶点即可, 具体的绘制方式就与纹理坐标和纹理数据没有关系了.
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)renderUsingIndex {
    
    const GLfloat texCoords[] = {
        0, 0, // 左下
        1, 0, // 右下
        0, 1, // 左上
        1, 1, // 右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0, // 左下
        1,  -1, 0, // 右下
        -1, 1,  0, // 左上
        1,  1,  0  // 右上
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
        0, 0, // 左下
        1, 0, // 右下
        0, 1, // 左上
        1, 1, // 右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0, // 左下
        1,  -1, 0, // 右下
        -1, 1,  0, // 左上
        1,  1,  0  // 右上
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
        0, 0, // 左下
        1, 0, // 右下
        0, 1, // 左上
        1, 1, // 右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLfloat vertices[] = {
        -1, -1, 0, // 左下
        1,  -1, 0, // 右下
        -1, 1,  0, // 左上
        1,  1,  0  // 右上
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
