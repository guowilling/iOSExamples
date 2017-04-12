//
//  ViewController.m
//  MapKit-自定义大头针-基本使用
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAnnotation.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign, getter=isFinishLocation) BOOL finishLocation;

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
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.mapView.rotateEnabled = NO;
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    SRAnnotation *anno = [[SRAnnotation alloc] init];
    anno.title = @"成都";
    anno.subtitle = @"软件园C区";
    CGFloat latitude = 31 + arc4random_uniform(11) * 0.1;
    CGFloat longitude = 104 + arc4random_uniform(11) * 0.1;
    anno.coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    [self.mapView addAnnotation:anno];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"name: %@ locality: %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
        if (self.isFinishLocation) {
            return;
        }
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.1);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
        self.finishLocation = YES;
    }];
}

@end
