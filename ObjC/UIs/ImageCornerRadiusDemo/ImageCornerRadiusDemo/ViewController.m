//
//  ViewController.m
//  ImageCornerRadiusDemo
//
//  Created by 郭伟林 on 2017/7/25.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+SRCornerRadius.h"
#import "UIImage+Rounding.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"coldplay.jpg"];
    
    UIImageView *imageView0 = [[UIImageView alloc] init];
    imageView0.image = image;
    imageView0.frame = CGRectMake(self.view.frame.size.width * 0.5 - 120 * 0.5, 50, 120, 120);
    [self.view addSubview:imageView0];
    
    UIImageView *imageView1 = [UIImageView sr_advanceRoundingRectImageView];
    imageView1.frame = CGRectMake(imageView0.frame.origin.x, CGRectGetMaxY(imageView0.frame) + 30, 120, 120);
    [self.view addSubview:imageView1];
    
    UIImageView *imageView2 = [UIImageView sr_advanceImageViewWithCornerRadius:20.f corners:UIRectCornerBottomLeft | UIRectCornerTopRight];
    imageView2.frame = CGRectMake(imageView0.frame.origin.x, CGRectGetMaxY(imageView1.frame) + 30, 120, 120);
    [self.view addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.frame = CGRectMake(imageView0.frame.origin.x, CGRectGetMaxY(imageView2.frame) + 30, 120, 120);
    [imageView3 sr_advanceCornerRadius:20.f corners:UIRectCornerBottomRight | UIRectCornerTopLeft];
    [imageView3 sr_attachBorderWithWidth:5.f color:[UIColor redColor]];
    [self.view addSubview:imageView3];
    
    imageView1.image = image;
    imageView2.image = image;
    imageView3.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    UIImage *image = [UIImage imageNamed:@"coldplay.jpg"];
    [UIImage roundingImageWithOriginalImage:image destSize:imageView.bounds.size fillColor:[UIColor whiteColor] completion:^(UIImage *roundedImage) {
        imageView.image = roundedImage;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
