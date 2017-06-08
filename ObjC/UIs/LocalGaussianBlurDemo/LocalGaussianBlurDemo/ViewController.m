//
//  ViewController.m
//  LocalGaussianBlurDemo
//
//  Created by 郭伟林 on 2017/6/8.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // https://github.com/LSure/SureBokehEffect
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    UIImage *originalImage = [UIImage imageNamed:@"test_image.jpeg"];
    CIImage *ciImage = [[CIImage alloc] initWithImage:originalImage];

    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:ciImage forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@20 forKey:kCIInputRadiusKey];
    
    CIFilter *radialFilter = [CIFilter filterWithName:@"CIRadialGradient"];
    [radialFilter setValue:[CIVector vectorWithX:originalImage.size.width / 2 Y:originalImage.size.height / 2 + 480] forKey:@"inputCenter"];
    [radialFilter setValue:@200 forKey:@"inputRadius0"];
    [radialFilter setValue:@400 forKey:@"inputRadius1"];
    
    CIFilter *maskFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [maskFilter setValue:ciImage forKey:kCIInputImageKey];
    [maskFilter setValue:gaussianBlurFilter.outputImage forKey:kCIInputBackgroundImageKey];
    [maskFilter setValue:radialFilter.outputImage forKey:kCIInputMaskImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef endImageRef = [context createCGImage:maskFilter.outputImage fromRect:ciImage.extent];
    UIImage *endImage = [UIImage imageWithCGImage:endImageRef];
    CGImageRelease(endImageRef);
    
    imageView.image = endImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
