//
//  ViewController.m
//  CoreLocation-区域监测
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 ) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    // 创建圆形区域
    // CLRegion 有两个子类专门用于指定区域: 一个指定蓝牙范围 / 一个指定圆形范围
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.058501, 116.304171); // 中心点
    CLCircularRegion *circular = [[CLCircularRegion alloc] initWithCenter:center radius:500 identifier:@"软件园"]; // 圆形区域
    [self.locationManager startMonitoringForRegion:circular]; // 开始检测用户所在的区域
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"进入监听区域");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    NSLog(@"离开监听区域");
}

@end
