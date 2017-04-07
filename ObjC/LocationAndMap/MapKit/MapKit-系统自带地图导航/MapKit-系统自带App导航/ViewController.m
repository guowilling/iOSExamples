//
//  ViewController.m
//  MapKit-系统自带App导航
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)startNavigation {
    
    NSString *startStr = self.startField.text;
    NSString *endStr = self.endField.text;
    if (startStr == nil || startStr.length == 0 || endStr == nil || endStr.length == 0) {
        NSLog(@"请输入起点终点");
        return;
    }
    
    [self.geocoder geocodeAddressString:startStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error) return;
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count == 0 || error) return;
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            [self startNavigationWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
    }];
    
    [self.startField resignFirstResponder];
    [self.endField resignFirstResponder];
}

- (void)startNavigationWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark {
    
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];;
    
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    NSArray *items = @[startItem, endItem];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving; // 导航模式: 驾车/走路
    options[MKLaunchOptionsMapTypeKey] = @(MKMapTypeStandard); // 地图类型
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

@end
