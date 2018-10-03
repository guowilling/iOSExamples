//
//  ViewController.m
//  YXFaceRecognition
//
//  Created by 郭伟林 on 2018/6/7.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)photoButtonAction:(id)sender {
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = NO;
//         UIImagePickerControllerSourceTypePhotoLibrary:相册（横向排列）
//         UIImagePickerControllerSourceTypeCamera：相机
//         UIImagePickerControllerSourceTypeSavedPhotosAlbum：相册(竖向排列)
        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;
    
    [self detectorFacewithImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)detectorFacewithImage:(UIImage *)image {
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    // 缩放图片的宽高和 imageView 一致, 保证识别出来的人脸坐标准确
    float factorW = self.imageView.bounds.size.width / image.size.width;
    float factorH = self.imageView.bounds.size.height / image.size.height;
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(factorW, factorH)];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:ciImage];
    for (CIFaceFeature *faceFeature in features) {
        // 脸部
        CGFloat faceWidth = faceFeature.bounds.size.width;
        UIView *faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        faceView.frame = CGRectMake(faceView.frame.origin.x,
                                    self.imageView.bounds.size.height-faceView.frame.origin.y-faceView.bounds.size.height,
                                    faceView.frame.size.width,
                                    faceView.frame.size.height);
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.imageView addSubview:faceView];
        
        // 左眼
        if (faceFeature.hasLeftEyePosition) {
            UIView *leftEyeView = [[UIView alloc] init];
            leftEyeView.frame = CGRectMake(faceFeature.leftEyePosition.x - faceWidth * 0.15,
                                           self.imageView.bounds.size.height-(faceFeature.leftEyePosition.y-faceWidth*0.15)-faceWidth*0.3,
                                           faceWidth*0.3,
                                           faceWidth*0.3);
            leftEyeView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            [self.imageView  addSubview:leftEyeView];
        }
      
        // 右眼
        if (faceFeature.hasRightEyePosition) {
            UIView *rightEyeView = [[UIView alloc] init];
            rightEyeView.frame = CGRectMake(faceFeature.rightEyePosition.x - faceWidth * 0.15,
                                            self.imageView.bounds.size.height-(faceFeature.rightEyePosition.y-faceWidth*0.15)-faceWidth*0.3,
                                            faceWidth*0.3,
                                            faceWidth*0.3);
            rightEyeView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            rightEyeView.layer.cornerRadius = faceWidth*0.15;
            [self.imageView  addSubview:rightEyeView];
        }
    
        // 嘴部
        if (faceFeature.hasMouthPosition) {
            UIView *mouthView = [[UIView alloc] init];
            mouthView.frame = CGRectMake(faceFeature.mouthPosition.x - faceWidth * 0.2,
                                         self.imageView.bounds.size.height-(faceFeature.mouthPosition.y-faceWidth*0.2)-faceWidth*0.4,
                                         faceWidth*0.4,
                                         faceWidth*0.4);
            mouthView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            mouthView.layer.cornerRadius = faceWidth*0.2;
            [self.imageView  addSubview:mouthView];
        }
    }
}

@end
