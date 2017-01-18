//
//  ViewController.m
//  PuzzlePhoto
//
//  Created by 郭伟林 on 17/1/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"coldplay.jpg"];
    UIImageView *imageView =[[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = CGRectMake(0, 0, 200, 200);
    imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, 550);
    [self.view addSubview:imageView];
    
    CGFloat width = image.size.width / 3;
    CGFloat heigh = image.size.height / 3;
    CGFloat magin = 5;
    CGFloat inset = ([UIScreen mainScreen].bounds.size.width - 300 - 2 * magin) * 0.5;
    NSMutableArray *arrayM =[NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int row = i / 3;
        int col = i % 3;
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(inset + col * (100 + magin), 100 + row * (100 + magin), 100, 100);
        btn.backgroundColor =[UIColor blackColor];
        [self.view addSubview:btn];
        btn.tag = 100 + i;
        if (i != 2) {
            CGRect rect = CGRectMake(col * width, row * heigh, width, heigh);
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
            UIImage *littleImage =[UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            [btn setImage:littleImage forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [arrayM addObject:[NSValue valueWithCGRect:btn.frame]];
    }
    
    NSMutableArray *randomNums =[NSMutableArray array];
    while (1) {
        int random = arc4random() % 9;
        BOOL iscontaint = NO;
        for (NSNumber *num in randomNums) {
            if ([num intValue]==random) {
                iscontaint = YES;
            }
        }
        if (!iscontaint) {
            [randomNums addObject:[NSNumber numberWithInt:random]];
        }
        if (randomNums.count == 9) {
            break;
        }
    }
    
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        int random = [randomNums[i] intValue];
        NSValue *value = arrayM[random];
        [frames addObject:value];
    }
    
    int index = 0;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = [frames[index++] CGRectValue];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    
    UIButton *blank = (UIButton *)[self.view viewWithTag:102];
    CGFloat x1 = blank.frame.origin.x;
    CGFloat y1 = blank.frame.origin.y;
    CGFloat x2 = btn.frame.origin.x;
    CGFloat y2 = btn.frame.origin.y;
    if ((x1 == x2 && fabs(y1 - y2) == 105) || (( y1 == y2 && fabs(x1 - x2) == 105))) {
        CGRect frame = blank.frame;
        blank.frame = btn.frame;
        btn.frame = frame;
    }
}

@end
