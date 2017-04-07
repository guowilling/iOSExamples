//
//  ViewController.m
//  CoreLocation-基本使用
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *loationManager;

@end

@implementation ViewController

- (CLLocationManager *)loationManager {
    
    if (!_loationManager) {
        _loationManager = [[CLLocationManager alloc] init];
        _loationManager.delegate = self;
        _loationManager.distanceFilter = 10; // 定位间隔距离
        _loationManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精确度
    }
    return _loationManager;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    // 1.iOS7 会自动向用户请求定位授权, iOS8需要手动向用户申请定位授权.
    // 2.iOS8 不仅要主动请求授权还需要在 info.plist 中配置属性: NSLocationWhenInUseDescription 或者 NSLocationAlwaysUsageDescription.
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.loationManager requestWhenInUseAuthorization];
    } else {
        [self.loationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"%s", __func__);
    
//    用户未选择权限
//    kCLAuthorizationStatusNotDetermined
//    
//    无法使用定位服务, 该状态用户无法改变
//    kCLAuthorizationStatusRestricted
//    
//    用户拒绝该应用使用定位服务，或是定位服务总开关处于关闭状态
//    kCLAuthorizationStatusDenied
//    
//    用户允许该应用在前台和后台时都可以使用定位服务
//    kCLAuthorizationStatusAuthorizedAlways
//    
//    用户允许该应用在前台时可以使用定位服务
//    kCLAuthorizationStatusAuthorizedWhenInUse
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待授权");
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"授权成功");
        [self.loationManager startUpdatingLocation];
    } else {
        NSLog(@"授权失败");
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%s", __func__);
    
//    location.coordinate            坐标 经纬度
//    location.altitude              海拔 米
//    location.course                前进方向 0北 90东 180南 270西
//    location.horizontalAccuracy    水平精准度
//    location.verticalAccuracy      垂直精准度
//    location.timestamp             定位返回的时间
//    location.speed                 设备移动速度 米/秒, 适用于行车速度
    
    CLLocation *location = [locations lastObject];
    NSLog(@"%f, %f; speed: %f", location.coordinate.latitude , location.coordinate.longitude, location.speed);
    //[self.loationManager stopUpdatingLocation];
}

@end
