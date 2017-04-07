//
//  ViewController.m
//  CoreLocation-汽车导航
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *previousLocation;

@property (nonatomic, assign) CLLocationDistance sumDistance;
@property (nonatomic, assign) NSTimeInterval sumTime;

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
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *nowLocation = [locations lastObject];
    if (self.previousLocation) {
        CLLocationDistance distance = [nowLocation distanceFromLocation:self.previousLocation]; // 两次之间的距离(米)
        NSTimeInterval dTime = [nowLocation.timestamp timeIntervalSinceDate:self.previousLocation.timestamp]; // 两次之间的时间(秒)
        CGFloat speed = distance / dTime; // 速度(米／秒)
        self.sumTime += dTime;
        self.sumDistance += distance;
        CGFloat avgSpeed = self.sumDistance / self.sumTime;
        NSLog(@"距离: %f; 时间: %f; 速度: %f; 平均速度: %f; 总路程: %f; 总时间: %f;",
              distance, dTime, speed, avgSpeed, self.sumDistance, self.sumTime);
        // 距离: 0.742466; 时间: 2.530748; 速度: 0.293378; 平均速度: 0.279825; 总路程: 3.229237; 总时间: 11.540219;
    }
    self.previousLocation = nowLocation;
}

@end
