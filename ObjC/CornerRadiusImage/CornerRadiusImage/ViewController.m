//
//  ViewController.m
//  CornerRadiusImage
//
//  Created by Willing Guo on 2017/3/14.
//  Copyright © 2017年 Willing Guo. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    imageView.layer.cornerRadius = imageView.bounds.size.width * 0.5;
//    imageView.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
//    imageView.image = [UIImage circleImageWithImage:image borderWidth:0 borderColor:[UIColor whiteColor]];
//    imageView.image = [image cornerRadiusImageWithSize:imageView.bounds.size fillColor:[UIColor whiteColor]];
    [image cornerRadiusImageWithSize:imageView.bounds.size fillColor:[UIColor whiteColor]
                          completion:^(UIImage *image) {
                              imageView.image = image;
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
