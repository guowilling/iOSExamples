//
//  ViewController.m
//  ImageEffectsDemo
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width  = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.bounces       = NO;
    scrollView.contentSize   = CGSizeMake(width * 4, height);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView        = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        imageView.contentMode         = UIViewContentModeScaleAspectFill;
        imageView.layer.borderWidth   = 4.f;
        imageView.layer.masksToBounds = YES;
        [scrollView addSubview:imageView];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            UIImage *image = nil;
            if (i == 0) {
                // Normal image
                image = [UIImage imageNamed:@"naruto"];
            } else if (i == 1) {
                // Blured image
                image = [[UIImage imageNamed:@"naruto"] blurImage];
            } else if (i == 2) {
                // Blured image at frame
                image = [UIImage imageNamed:@"naruto"];
                image = [image blurImageAtFrame:CGRectMake(0, 0, image.size.width, image.size.height * 0.5)];
            } else {
                // GrayScale image
                image = [[UIImage imageNamed:@"naruto"] grayImage];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        });
    }
}

@end
