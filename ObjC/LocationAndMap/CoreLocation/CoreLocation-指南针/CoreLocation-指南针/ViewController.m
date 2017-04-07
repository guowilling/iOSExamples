//
//  ViewController.m
//  CoreLocation-指南针
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIImageView *compass;

@end

@implementation ViewController

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UIImageView *)compass {
    
    if (!_compass) {
        _compass = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"bg_compasspointer"]];
        _compass.center = CGPointMake(self.view.center.x, self.view.center.y);
    }
    return _compass;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.compass];
    
    // 方向信息不需要请求用户授权
    [self.locationManager startUpdatingHeading];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    // magneticHeading  设备与磁北的相对角度
    // trueHeading      设备与真北的相对角度, 必须和定位一起使用, iOS需要位置来计算真北, 真北始终指向地理北极点
    CGFloat angle = newHeading.magneticHeading * M_PI / 180;
    self.compass.transform = CGAffineTransformMakeRotation(-angle);
}

@end
