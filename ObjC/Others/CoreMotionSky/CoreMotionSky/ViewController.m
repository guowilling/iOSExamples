//
//  ViewController.m
//  CoreMotionSky
//
//  Created by 郭伟林 on 2018/7/4.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) AVCaptureDevice *backCameraDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureOutput;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

static CGFloat multiplier = 5;

@implementation ViewController

#pragma mark - Lazy Load

- (AVCaptureDevice *)backCameraDevice {
    if (!_backCameraDevice) {
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *camera in cameras) {
            if (camera.position == AVCaptureDevicePositionBack) {
                _backCameraDevice = camera;
            }
        }
    }
    return _backCameraDevice;
}

- (AVCaptureDeviceInput *)captureInput {
    if (!_captureInput) {
        _captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.backCameraDevice error:nil];
    }
    return _captureInput;
}

- (AVCaptureStillImageOutput *)captureOutput {
    if (!_captureOutput) {
        _captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *setting = @{AVVideoCodecKey: AVVideoCodecJPEG};
        [_captureOutput setOutputSettings:setting];
    }
    return _captureOutput;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        if([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        }
    }
    return _captureSession;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCamera];
    
    [self setupSKY];
}

- (void)setupCamera {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusAuthorized:
            [self providVideoLayer];
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self providVideoLayer];
                }
            }];
            break;
    }
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

- (void)providVideoLayer {
    if ([self.captureSession canAddInput:self.captureInput]) {
        [self.captureSession addInput:self.captureInput];
    }
    if ([self.captureSession canAddOutput:self.captureOutput]) {
        [self.captureSession addOutput:self.captureOutput];
    }
    [self.captureSession startRunning];
    if ([self.backCameraDevice lockForConfiguration:nil]) {
        if ([self.backCameraDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.backCameraDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        if ([self.backCameraDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.backCameraDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.backCameraDevice unlockForConfiguration];
    }
}

- (void)setupSKY {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sky"]];
    // 星空图分辨率是 4000*2800, 让 imageView 超出屏幕
    imageView.frame = CGRectMake(-self.view.frame.size.width,
                                 -(self.view.frame.size.height * 0.5),
                                 self.view.frame.size.width + self.view.frame.size.width * 2,
                                 self.view.frame.size.height + self.view.frame.size.height);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    if (self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 1 / 30;
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            // 防抖动的处理, 如果手机旋转的不太大就不执行操作
            if (fabs(gyroData.rotationRate.x) * multiplier < 0.2 && fabs(gyroData.rotationRate.y) * multiplier < 0.2) {
                return;
            }
            CGFloat imageRotationX = imageView.center.x + gyroData.rotationRate.x * multiplier;
            CGFloat imageRotationY = imageView.center.y + gyroData.rotationRate.y * multiplier;
            if (imageRotationX > self.view.frame.size.width * 1.5) {
                imageRotationX = self.view.frame.size.width * 1.5;
            }
            if (imageRotationX < (- self.view.frame.size.width * 0.5)){
                imageRotationX = (- self.view.frame.size.width * 0.5);
            }
            if (imageRotationY > self.view.frame.size.height) {
                imageRotationY = self.view.frame.size.height;
            }
            if (imageRotationY < 0) {
                imageRotationY = 0;
            }
            [UIView animateWithDuration:0.25
                                  delay:0.05
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction |
             UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 imageView.center = CGPointMake(imageRotationX, imageRotationY);
                             } completion:nil];
        }];
    }
}

@end
