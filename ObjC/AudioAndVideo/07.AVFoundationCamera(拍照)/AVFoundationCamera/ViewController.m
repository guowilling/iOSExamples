
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^ChangePropertyHandler)(AVCaptureDevice *captureDevice);

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView      *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton    *flashAutoButton;
@property (weak, nonatomic) IBOutlet UIButton    *flashOnButton;
@property (weak, nonatomic) IBOutlet UIButton    *flashOffButton;
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor;

@property (strong, nonatomic) AVCaptureSession           *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput       *captureDeviceInput;
@property (strong, nonatomic) AVCaptureStillImageOutput  *captureStillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property(nonatomic,assign)CGFloat beginGestureScale;
@property(nonatomic,assign)CGFloat endGestureScale;

@end

@implementation ViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _beginGestureScale = 1.0;
    _endGestureScale = 1.0;
    
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) { // 分辨率
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    // 输入设备
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack]; // 后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头失败!");
        return;
    }
    
    // 初始化设备输入对象
    NSError *error;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象失败: %@", error.localizedDescription);
        return;
    }
    // 添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    // 初始化设备输出对象
    _captureStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [_captureStillImageOutput setOutputSettings:@{AVVideoCodecKey: AVVideoCodecJPEG}];
    // 添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    // 初始化摄像头预览图层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    
    [self addGenstureRecognizer];
    
    [self setFlashModeButtonStatus];
    
    [self addNotificationToCaptureSession:_captureSession];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

- (void)addGenstureRecognizer {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScreen:)];
    pinchGesture.delegate = self;
    [self.viewContainer addGestureRecognizer:pinchGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint point = [tapGesture locationInView:self.viewContainer];
    // Converts a point from layer coordinates to the coordinate space of the capture device.
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

- (void)pinchScreen:(UIPinchGestureRecognizer *)panGesture {
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    
    NSUInteger touches = [panGesture numberOfTouches];
    for (NSUInteger touchIndex = 0; touchIndex < touches; touchIndex++) {
        CGPoint point = [panGesture locationOfTouch:touchIndex inView:self.viewContainer];
        CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
        if (![self.captureVideoPreviewLayer containsPoint:cameraPoint] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if (!allTouchesAreOnThePreviewLayer) {
        return;
    }
    self.endGestureScale = self.beginGestureScale * panGesture.scale;
    if (self.endGestureScale < 1.0){
        self.endGestureScale = 1.0;
    }
    CGFloat maxScaleAndCropFactor = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo].videoMaxScaleAndCropFactor;
    if (self.endGestureScale > maxScaleAndCropFactor) {
        self.endGestureScale = maxScaleAndCropFactor;
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(self.endGestureScale, self.endGestureScale)];
    [CATransaction commit];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.endGestureScale;
    }
    return YES;
}

- (AVCaptureVideoOrientation)captureVideoOrientationOfDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    AVCaptureVideoOrientation captureVideoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        captureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        captureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    return captureVideoOrientation;
}

#pragma mark - Actions

- (IBAction)takeButtonClick:(UIButton *)sender {
    
    AVCaptureConnection *captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoOrientation captureVideoOrientation = [self captureVideoOrientationOfDeviceOrientation:[UIDevice currentDevice].orientation];
    [captureConnection setVideoOrientation:captureVideoOrientation];
    [captureConnection setVideoScaleAndCropFactor:self.endGestureScale];
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            [self saveImageToPhotosAlbum:image];
        }
    }];
}

- (void)saveImageToPhotosAlbum:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
//    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied){
//        return;
//    }
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        NSLog(@"保存图片成功");
    }
}

- (IBAction)toggleButtonClick:(UIButton *)sender {
    
    AVCaptureDevice *currentDevice = [self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    [self.captureSession beginConfiguration]; // 改变会话配置前一定要先开启配置, 配置完成后再提交配置改变.
    [self.captureSession removeInput:_captureDeviceInput]; // 移除旧输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) { // 添加新输入对象
        [self.captureSession addInput:toChangeDeviceInput];
        _captureDeviceInput = toChangeDeviceInput;
    }
    [self.captureSession commitConfiguration];
    
    [self setFlashModeButtonStatus];
}

- (IBAction)flashAutoClick:(UIButton *)sender {
    
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}

- (IBAction)flashOnClick:(UIButton *)sender {
    
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];
}

- (IBAction)flashOffClick:(UIButton *)sender {
    
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];
}

#pragma mark - NSNotification

- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES; // 添加区域改变捕获通知前, 需要设置设备允许捕获.
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

- (void)areaDidChange:(NSNotification *)notification {
    
    NSLog(@"areaDidChange");
}

- (void)sessionRuntimeError:(NSNotification *)notification {
    
    NSLog(@"sessionRuntimeError");
}

#pragma mark - Assist Methods

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

- (void)changeDeviceProperties:(ChangePropertyHandler)handler {
    
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) { // Must lock!
        handler(captureDevice);
        [captureDevice unlockForConfiguration]; // Must unlock!
    } else {
        NSLog(@"changeDeviceProperties error: %@", error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
- (void)setFlashMode:(AVCaptureFlashMode )flashMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
- (void)setFocusMode:(AVCaptureFocusMode )focusMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        } else if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        } else if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        } else if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

- (void)setFlashModeButtonStatus {
    
    AVCaptureDevice *captureDevice = [self.captureDeviceInput device];
    AVCaptureFlashMode flashMode = captureDevice.flashMode;
    if ([captureDevice isFlashAvailable]) {
        self.flashAutoButton.hidden = NO;
        self.flashOnButton.hidden = NO;
        self.flashOffButton.hidden = NO;
        self.flashAutoButton.enabled = YES;
        self.flashOnButton.enabled = YES;
        self.flashOffButton.enabled = YES;
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled = NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled = NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled = NO;
                break;
        }
    } else {
        self.flashAutoButton.hidden = YES;
        self.flashOnButton.hidden = YES;
        self.flashOffButton.hidden = YES;
    }
}

- (void)setFocusCursorWithPoint:(CGPoint)point {
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

@end
