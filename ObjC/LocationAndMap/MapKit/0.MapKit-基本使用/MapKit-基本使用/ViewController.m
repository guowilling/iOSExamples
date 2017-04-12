//
//  ViewController.m
//  MapKit-基本使用
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

/**
 * 错误: Terminating app due to uncaught exception 'NSInvalidUnarchiveOperationException', reason: 'Could not instantiate class named MKMapView'
 * 原因: 如果 storyboard 中使用了 MKMapView 必须手动导入框架
 */

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKUserLocation *currentUserLocation;

@end

@implementation ViewController

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.rotateEnabled = NO;
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow; // 设置追踪模式后可以通过 MapKit 定位, 但需要请求用户授权.
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    /**
     * 大头针有: 标题/子标题/位置信息
     * 大头针显示的内容由大头针模型MKUserLocation确定
     */
    
    NSString *currentAddress = self.currentUserLocation.title;
    
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"name: %@ locality: %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
        self.currentUserLocation = userLocation;
    }];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] <= 8.0) { // iOS8之前不会自动移动到用户当前位置
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    }
    
    if ([self.currentUserLocation.title isEqualToString:currentAddress]) {
        return;
    }
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.100000, 0.100000);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    NSLog(@"regionDidChangeAnimated");

    NSLog(@"latitudeDelta: %f; longitudeDelta: %f", self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);
}

@end
