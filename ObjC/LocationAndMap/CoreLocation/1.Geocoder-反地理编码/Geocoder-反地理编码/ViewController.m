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
        //placemarks.firstObject
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
        
        /**
         CLPlacemark 属性含义:
         name                   地名
         
         thoroughfare           街道
         
         subThoroughfare        街道相关信息, 门牌等
         
         locality               城市
         
         subLocality            城市相关信息, 标志性建筑等
         
         administrativeArea     直辖市
         
         subAdministrativeArea  其他行政区域信息, 自治区等
         
         postalCode             邮编
         
         ISOcountryCode         国家编码
         
         country                国家
         
         inlandWater            水源, 湖泊
         
         ocean                  海洋
         
         areasOfInterest        关联的或利益相关的地标
         */
        
    }];
}

@end
