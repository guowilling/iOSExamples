
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void(^ChangePropertyHandler)(AVCaptureDevice *captureDevice);

@interface ViewController () <AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (assign, nonatomic) BOOL enableRotation; // 视频录制过程中禁止屏幕旋转
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor;

@end

@implementation ViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _enableRotation = YES;
    
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    AVCaptureDevice *cameraCaptureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!cameraCaptureDevice) {
        return;
    }
    NSError *error;
    _videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraCaptureDevice error:&error];
    if (error) {
        NSLog(@"视频输入设备 error: %@", error.localizedDescription);
        return;
    }
    
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"音频输入设备 error: %@", error.localizedDescription);
        return;
    }
    
    if ([_captureSession canAddInput:_videoCaptureDeviceInput]) {
        [_captureSession addInput:_videoCaptureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if (captureConnection.isVideoStabilizationSupported) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    CALayer *layer = self.viewContainer.layer;
    layer.masksToBounds = YES;
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:cameraCaptureDevice];
    
    [self addGenstureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

- (BOOL)shouldAutorotate {
    
    return self.enableRotation;
}

// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = (AVCaptureVideoOrientation)toInterfaceOrientation; // 屏幕旋转时调整视频预览图层的方向
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    _captureVideoPreviewLayer.frame = self.viewContainer.bounds; // 屏幕旋转后调整视频预览图层的大小
}

- (IBAction)startRecording {

    if ([self.captureMovieFileOutput isRecording]) {
        return;
    }
    AVCaptureConnection *captureConnection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    self.enableRotation = NO;
    if ([[UIDevice currentDevice] isMultitaskingSupported]) { // 如果支持多任务则开启多任务
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    }
    captureConnection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation; // 视频方向和预览图层方向保持一致
    NSString *fielPath = [NSTemporaryDirectory() stringByAppendingString:@"tmpMovie.mov"];
    NSLog(@"fielPath: %@", fielPath);
    NSURL *fileURL = [NSURL fileURLWithPath:fielPath];
    NSLog(@"fileURL: %@", fileURL);
    [self.captureMovieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}

- (IBAction)endRcording {
    
    [self.captureMovieFileOutput stopRecording];
}

- (IBAction)toggleButtonClick:(UIButton *)sender {
    
    AVCaptureDevice *currentDevice = [self.videoCaptureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.videoCaptureDeviceInput = toChangeDeviceInput;
    }
    [self.captureSession commitConfiguration];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    
    NSLog(@"开始录像");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    NSLog(@"结束录像");
    
    self.enableRotation = YES;
    
    // 录像完成之后在后台将视频保存到相簿
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频失败: %@", error.localizedDescription);
        } else {
            NSLog(@"保存视频成功");
        }
        NSLog(@"outputFileURL: %@", outputFileURL);
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        if (lastBackgroundTaskIdentifier != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
    }];
    
    [self presentMoviePlayerViewControllerAnimated:[[MPMoviePlayerViewController alloc] initWithContentURL:outputFileURL]];
}

- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

- (void)areaChange:(NSNotification *)notification {
    
}

- (void)sessionRuntimeError:(NSNotification *)notification {
    
}

- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position {
    
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

- (void)changeDeviceProperties:(ChangePropertyHandler)handler {
    
    AVCaptureDevice *captureDevice = [self.videoCaptureDeviceInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        handler(captureDevice);
        [captureDevice unlockForConfiguration];
    }
}

- (void)setFlashMode:(AVCaptureFlashMode )flashMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

- (void)setFocusMode:(AVCaptureFocusMode )focusMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

- (void)setExposureMode:(AVCaptureExposureMode)exposureMode {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    
    [self changeDeviceProperties:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
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

- (void)addGenstureRecognizer {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.viewContainer addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint point = [tapGesture locationInView:self.viewContainer];
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

@end
