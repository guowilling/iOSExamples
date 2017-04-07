//
//  ViewController.m
//  MapKit-自定义大头针-Pin
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRAnnotation.h"
#import "SRAnnotationView.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

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
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    SRAnnotation *annotation1 = [[SRAnnotation alloc] init];
    annotation1.title = @"成都";
    annotation1.subtitle = @"软件园B区";
    CGFloat latitude = 32 + arc4random_uniform(11) * 0.1;
    CGFloat longitude = 105 + arc4random_uniform(11) * 0.1;
    annotation1.coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    annotation1.icon = @"category_4";
    [self.mapView addAnnotation:annotation1];
    
    SRAnnotation *annotation2 = [[SRAnnotation alloc] init];
    annotation2.title = @"成都";
    annotation2.subtitle = @"软件园C区";
    CGFloat latitude2 = 32 + arc4random_uniform(11) * 0.1;
    CGFloat longitude2 = 105 + arc4random_uniform(11) * 0.1;
    annotation2.coordinate = CLLocationCoordinate2DMake(latitude2 , longitude2);
    annotation2.icon = @"category_5";
    [self.mapView addAnnotation:annotation2];
}

- (void)addPinAnnotationView {
    
    // Notice:
    // 1.默认 MKAnnotationView 无法显示, 使用 MKAnnotationView 的子类 MKPinAnnotationView
    // 2.默认点击自定义大头针不会显示标题, 需要手动设置
    
    static NSString *identifier = @"pinAnnotationView";
    MKPinAnnotationView *pinAnnoView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinAnnoView == nil) {
        pinAnnoView = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
        // 大头针颜色
        //pinAnnoView.pinColor = MKPinAnnotationColorPurple;
        // 大头针是否动画显示
        pinAnnoView.animatesDrop = YES;
        // 点击大头针是否显示标题
        pinAnnoView.canShowCallout = YES;
        // 大头针标题的偏移位
        pinAnnoView.calloutOffset = CGPointMake(-50, 0);
        // 大头针左边的辅助视图
        pinAnnoView.leftCalloutAccessoryView = [[UISwitch alloc] init];
        // 大头针右边的辅助视图
        pinAnnoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    // 大头针的图片
    // Notice: MKPinAnnotationView 设置图片无效因为系统内部会做一些操作覆盖我们的设置
    //pinAnnoView.image = [UIImage imageNamed:@"category_4"];
}

#pragma mark - MKMapViewDelegate

/**
 *  每次添加大头针时调用
 *
 *  @param mapView    地图
 *  @param annotation 大头针模型
 *
 *  @return 大头针视图
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    //[self addPinAnnotationView];

    if (![annotation isKindOfClass:[SRAnnotation class]]) { // 系统大头针交给系统处理
        return nil;
    }
    SRAnnotationView *annotationView = [SRAnnotationView annotationViewWithMap:mapView];
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"name: %@ locality: %@", placemark.name, placemark.locality);
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(2, 2);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:YES];
    //[self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

@end
