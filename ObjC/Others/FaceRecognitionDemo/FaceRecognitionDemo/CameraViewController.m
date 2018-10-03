//
//  CameraViewController.m
//  YXFaceRecognition
//
//  Created by 郭伟林 on 2018/6/7.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) CIDetector *detector;

@end

@implementation CameraViewController

- (CIDetector *)detector {
    if (!_detector) {
        _detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                       context:nil
                                       options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh,
                                                 CIDetectorMinFeatureSize: @(0.2),
                                                 CIDetectorTracking: @(YES)}];
    }
    return _detector;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    NSArray<AVCaptureDevice *> *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionFront) {
                self.captureDevice = device;
            }
        }
    }
    
    AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:nil];
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_queue_create("cameraQueue", DISPATCH_QUEUE_SERIAL)];
    output.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInteger:kCVPixelFormatType_32BGRA]};
    [self.captureSession addOutput:output];

    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.previewLayer];
    
    [self.view addSubview:self.maskView];
    
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
        UIImage *resultImage = [self sampleBufferToImage:sampleBuffer];
        resultImage = [self fixOrientation:resultImage];
        
        float factorW = self.view.bounds.size.width / resultImage.size.width;
        float factorH = self.view.bounds.size.height / resultImage.size.height;
        
        CIImage *ciImage = [[CIImage alloc] initWithImage:resultImage];
        ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(factorW, factorH)];
        NSArray<CIFaceFeature *> *features = (NSArray<CIFaceFeature *> *)[self.detector featuresInImage:ciImage];
        
        for (CIFaceFeature *feature in features) {
            NSLog(@"trackingID = %d", feature.trackingID);
            NSLog(@"trackingFrameCount = %d", feature.trackingFrameCount);
            
            CALayer *faceLayer = [self redLayer];
            faceLayer.frame = CGRectMake(feature.bounds.origin.x,
                                         self.view.frame.size.height - feature.bounds.origin.y - feature.bounds.size.height,
                                         feature.bounds.size.width,
                                         feature.bounds.size.height);
            
            CGFloat halfWidth = 5;
            CALayer *mouthLayer = [self redLayer];
            mouthLayer.frame = CGRectMake(feature.mouthPosition.x - halfWidth,
                                          (self.view.frame.size.height - feature.mouthPosition.y) - halfWidth,
                                          halfWidth * 2,
                                          halfWidth * 2);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.maskView.layer.sublayers.count > 0) {
                    for (int i = (int)self.maskView.layer.sublayers.count; i > 0; i--) {
                        [self.maskView.layer.sublayers[i-1] removeFromSuperlayer];
                    }
                }
                [self.maskView.layer addSublayer:faceLayer];
                [self.maskView.layer addSublayer:mouthLayer];
            });
        }
}

- (CALayer *)redLayer {
    CALayer *redLayer = [[CALayer alloc] init];
    redLayer.borderWidth = 2;
    redLayer.borderColor = [UIColor redColor].CGColor;
    return redLayer;
}

- (UIImage *)sampleBufferToImage:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
    UIImage *result = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(videoImage);
    return result;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
