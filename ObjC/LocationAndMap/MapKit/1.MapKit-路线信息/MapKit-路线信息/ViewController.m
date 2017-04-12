//
//  ViewController.m
//  MapKit-路线信息
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
        if (placemarks.count == 0) return;
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count == 0) return;
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            [self startDirectionsWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
    }];
    
    [self.startField resignFirstResponder];
    [self.endField resignFirstResponder];
}

- (void)startDirectionsWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark {
    
    // MKDirectionsRequest:  从哪里到哪里
    // MKDirectionsResponse: 具体路线信息
    
    MKPlacemark *startMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMKPlacemark];
    MKPlacemark *endMKPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMKPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = startItem;
    request.destination = endItem;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSArray *routes = response.routes;
        for (MKRoute *route in routes) {
            NSLog(@"%f千米 %f小时", route.distance / 1000, route.expectedTravelTime / 3600);
            NSArray *steps = route.steps;
            for (MKRouteStep *step in steps) {
                NSLog(@"%@", step.instructions);
            }
        }
    }];
}

@end
