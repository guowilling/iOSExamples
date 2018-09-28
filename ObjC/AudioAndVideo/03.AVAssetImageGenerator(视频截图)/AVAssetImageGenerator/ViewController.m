
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [self imageOfVideoAtTime:5.0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}

- (UIImage *)imageOfVideoAtTime:(CGFloat )time {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jieshaoshiping.mp4" ofType:nil];
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    NSError *error = nil;
    
    // CMTimeMakeWithSeconds:
    // 第一个参数是视频第几秒
    // 第二个参数是每秒帧数
    // Note: 如果要获得某秒的第几帧可以使用 CMTimeMake 方法构造 CMTime
    CMTime cmTime = CMTimeMakeWithSeconds(time, 10);
    CMTime actualTime;
    CGImageRef imageRef= [imageGenerator copyCGImageAtTime:cmTime actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"截取视频缩略图失败: %@", error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    CGImageRelease(imageRef);
    
    return image;
}

@end
