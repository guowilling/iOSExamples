
#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (assign, nonatomic, getter=isRecordingVideo) BOOL recordingVideo;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.recordingVideo = YES;
}

- (IBAction)takePicAction {
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (UIImagePickerController *)imagePickerController {
    
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; // 相机
        _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear; // 后置摄像头
        if (self.isRecordingVideo) {
            _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
            _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo; // 录像
        } else {
            _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto; // 拍照
        }
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 拍照
        UIImage *image;
        if (self.imagePickerController.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.imageView.image = image;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        // 录像
        NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(URL.path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(URL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        NSLog(@"视频保存失败! error: %@", error.localizedDescription);
        return;
    }
    NSLog(@"视频保存成功!");
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.imageView.frame;
    [self.imageView.layer addSublayer:playerLayer];
    [player play];
}

@end
