//
//  ViewController.m
//  Geocoder-反地理编码
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (nonatomic ,strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UITextField *longtitudeField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UILabel *reverseDetailAddressLabel;

@end

@implementation ViewController

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)reverseGeocode {
    
    NSString *longtitude = self.longtitudeField.text;
    NSString *latitude = self.latitudeField.text;
    if (longtitude == nil || longtitude.length == 0 || latitude == nil || latitude.length == 0) {
        NSLog(@"请输入经纬度");
        return;
    }
    
    // 通过地理编码对象反编码 CLLocation 得到对应的地标
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longtitude doubleValue]];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        for (CLPlacemark *placemark in placemarks) {
            NSLog(@"%@", placemark.name);
            NSLog(@"%@", placemark.addressDictionary);
            NSLog(@"%@", placemark.location);
            NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
            NSMutableString *strM = [NSMutableString string];
            for (NSString *str in address) {
                [strM appendString:str];
            }
            self.reverseDetailAddressLabel.text = strM;
        }
    }];
}

@end
