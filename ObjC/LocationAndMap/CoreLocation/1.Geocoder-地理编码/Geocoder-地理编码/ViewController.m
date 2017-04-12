//
//  ViewController.m
//  Geocoder-地理编码
//
//  Created by 郭伟林 on 16/3/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;

@property (nonatomic ,strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)geocodeBtnClick {
    
    NSString *addressStr = self.addressField.text;
    if (addressStr == nil || addressStr.length == 0) {
        NSLog(@"请输入地址");
        return;
    }
    
    // 通过地理编码对象编码地址得到对应的地标
    [self.geocoder geocodeAddressString:addressStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0 || error != nil) {
            return;
        }
        NSLog(@"placemarks: %@", placemarks);
        // 地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等
        CLPlacemark *placemark = [placemarks firstObject];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
        NSArray *address = placemark.addressDictionary[@"FormattedAddressLines"];
        NSMutableString *strM = [NSMutableString string];
        for (NSString *str in address) {
            [strM appendString:str];
        }
        self.detailAddressLabel.text = strM;
    }];
}

@end
