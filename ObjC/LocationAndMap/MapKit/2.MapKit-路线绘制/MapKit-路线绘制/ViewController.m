//
//  ViewController.m
//  MapKit-路线绘制
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAnnotation.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mapView.delegate = self;
}

- (IBAction)drawLine {
    
    [self.geocoder geocodeAddressString:@"成都" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) {
            return;
        }
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        SRAnnotation *startAnno = [[SRAnnotation alloc ] init];
        startAnno.title = startCLPlacemark.locality;
        startAnno.subtitle = startCLPlacemark.name;
        startAnno.coordinate = startCLPlacemark.location.coordinate;
        [self.mapView addAnnotation:startAnno];
        
        [self.geocoder geocodeAddressString:@"北京" completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count == 0) {
                return;
            }
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            SRAnnotation *endAnno = [[SRAnnotation alloc ] init];
            endAnno.title = endCLPlacemark.locality;
            endAnno.subtitle = endCLPlacemark.name;
            endAnno.coordinate = endCLPlacemark.location.coordinate;
            [self.mapView addAnnotation:endAnno];
            
            [self startDirectionsWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
        }];
    }];
}

- (void)startDirectionsWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark {
    
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
            NSLog(@"%.2f千米 %.2f小时", route.distance / 1000, route.expectedTravelTime / 3600);
            [self.mapView addOverlay:route.polyline]; // 路线的绘制本质是添加遮盖到地图
            NSArray *steps = route.steps;
            for (MKRouteStep *step in steps) {
                NSLog(@"%@", step.instructions);
            }
        }
    }];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    render.lineWidth = 5;
    render.strokeColor = [UIColor blueColor];
    return render;
}

@end
