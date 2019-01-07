//
//  ViewController.m
//  CustomMapPin
//
//  Created by 郭伟林 on 17/2/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UIAssistDefine.h"
#import "NSString+Extension.h"
#import "UIView+Frame.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self customMapPinWithIcon];
    
    [self customMapPinWithoutIcon];
}

- (void)customMapPinWithIcon {
    [self.view addSubview:({
        UIView *pinContainer = [[UIView alloc] init];
//        pinContainer.backgroundColor = COLOR_RANDOM;
        
        UIView *commentContainer = [[UIView alloc] init];
        [pinContainer addSubview:({
            NSString *commentText = @"我是评论内容";
            CGSize textSize = [commentText sizeWithFont:[UIFont systemFontOfSize:SCREEN_ADJUST(17)] maxHeight:SCREEN_ADJUST(20)];
            if (textSize.width > 100) {
                textSize.width = 100;
            }
            commentContainer.frame = CGRectMake(0, 0, textSize.width + textSize.height + textSize.height + 20, textSize.height + 20);
            
            UILabel *commentLable = [[UILabel alloc] init];
            commentLable.frame = CGRectMake(commentContainer.frame.size.height * 0.5, 5,
                                            commentContainer.frame.size.width - commentContainer.frame.size.height * 0.5, commentContainer.frame.size.height - 10);
            commentLable.layer.cornerRadius = commentLable.frame.size.height * 0.5;
            commentLable.layer.masksToBounds = YES;
            commentLable.text = [NSString stringWithFormat:@"      %@", commentText];
            commentLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
            commentLable.textAlignment = NSTextAlignmentLeft;
            commentLable.textColor = [UIColor whiteColor];
            commentLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
            [commentContainer addSubview:commentLable];
            
            UIImageView *avatar = [[UIImageView alloc] init];
            avatar.image = [UIImage imageNamed:@"tempAvatar.jpeg"];
            avatar.frame = CGRectMake(0, 0, commentContainer.frame.size.height, commentContainer.frame.size.height);
            avatar.layer.cornerRadius = avatar.frame.size.height * 0.5;
            avatar.layer.masksToBounds = YES;
            [commentContainer addSubview:avatar];
            
            [avatar.layer addSublayer:({
                CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
                gradientLayer.frame = avatar.bounds;
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint   = CGPointMake(1.0, 0);
                NSMutableArray *colors = [NSMutableArray array];
                [colors addObject:(id)[UIColor colorWithRed:247/255.0 green:107/255.0  blue:28/255.0 alpha:1.0].CGColor];
                [colors addObject:(id)[UIColor colorWithRed:250/255.0 green:97/255.0  blue:162/255.0 alpha:1.0].CGColor];
                [gradientLayer setColors:[NSArray arrayWithArray:colors]];
                
                UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(gradientLayer.bounds),
                                                                                             CGRectGetMidY(gradientLayer.bounds))
                                                                          radius:gradientLayer.bounds.size.width * 0.5
                                                                      startAngle:0
                                                                        endAngle:2 * M_PI
                                                                       clockwise:NO];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.path          = circlePath.CGPath;
                shapeLayer.strokeColor   = [UIColor lightGrayColor].CGColor;
                shapeLayer.fillColor     = [[UIColor clearColor] CGColor];
                shapeLayer.lineWidth     = 3;
                shapeLayer.strokeStart   = 0;
                shapeLayer.strokeEnd     = 1.0;
                gradientLayer.mask = shapeLayer;
                gradientLayer;
            })];
            
            commentContainer;
        })];
        
        [pinContainer addSubview:({
            UIImageView *locationIcon = [[UIImageView alloc] init];
            locationIcon.image = [UIImage imageNamed:@"locationIndicator"];
            locationIcon.contentMode = UIViewContentModeCenter;
            locationIcon.frame = CGRectMake(commentContainer.frame.size.width * 0.5 - commentContainer.frame.size.height * 0.5, commentContainer.frame.size.height,
                                            commentContainer.frame.size.height, commentContainer.frame.size.height);
            locationIcon;
        })];
        
        pinContainer.frame = CGRectMake(0, 0, commentContainer.frame.size.width, commentContainer.frame.size.height * 2);
        pinContainer.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5 - 100);
        pinContainer;
    })];
}

- (void)customMapPinWithoutIcon {
    UIView *commentContainer = [[UIView alloc] init];
//    commentContainer.backgroundColor = COLOR_RANDOM;
    
    NSString *commentText = @"COLDPLAY";
    CGSize textSize = [commentText sizeWithFont:[UIFont systemFontOfSize:SCREEN_ADJUST(15)] maxHeight:SCREEN_ADJUST(20)];
    if (textSize.width > 100) {
        textSize.width = 100;
    }
    UILabel *commentLable;
    [commentContainer addSubview:({
        commentLable = [[UILabel alloc] init];
        commentLable.text = [NSString stringWithFormat:@"      %@", commentText];
        commentLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
        commentLable.textAlignment = NSTextAlignmentLeft;
        commentLable.textColor = [UIColor whiteColor];
        commentLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        commentLable;
    })];
    
    UIImageView *avatar;
    [commentContainer addSubview:({
        avatar = [[UIImageView alloc] init];
        avatar;
    })];
    CGFloat commentContainerH = textSize.height + 20;
    CGFloat commentContainerW = commentContainerH + textSize.width + textSize.height * 2;
    commentContainer.frame = CGRectMake(0, 0, ceil(commentContainerW), ceil(commentContainerH));
    
    avatar.frame = CGRectMake(0, 0, commentContainer.yx_height, commentContainer.yx_height);
    avatar.layer.cornerRadius = avatar.frame.size.height * 0.5;
    avatar.layer.masksToBounds = YES;
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    avatar.image = [UIImage imageNamed:@"tempAvatar.jpeg"];
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = avatar.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:(id)[UIColor colorWithRed:247/255.0 green:107/255.0  blue:28/255.0 alpha:1.0].CGColor];
    [colors addObject:(id)[UIColor colorWithRed:250/255.0 green:97/255.0  blue:162/255.0 alpha:1.0].CGColor];
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(gradientLayer.bounds), CGRectGetMidY(gradientLayer.bounds))
                                                              radius:gradientLayer.bounds.size.width * 0.5
                                                          startAngle:0
                                                            endAngle:2 * M_PI
                                                           clockwise:NO];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path          = circlePath.CGPath;
    shapeLayer.strokeColor   = [UIColor lightGrayColor].CGColor;
    shapeLayer.fillColor     = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth     = 3;
    shapeLayer.strokeStart   = 0;
    shapeLayer.strokeEnd     = 1.0;
    gradientLayer.mask = shapeLayer;
    [avatar.layer addSublayer:gradientLayer];
    
    commentLable.frame = CGRectMake(commentContainer.yx_height * 0.5, 5, commentContainer.yx_width - commentContainer.yx_height * 0.5, commentContainer.yx_height - 10);
    commentLable.layer.cornerRadius = commentLable.yx_height * 0.5;
    commentLable.layer.masksToBounds = YES;
    
    commentContainer.yx_centerX = self.view.yx_centerX;
    commentContainer.yx_centerY = self.view.yx_centerY + 100;
    [self.view addSubview:commentContainer];
}

@end
