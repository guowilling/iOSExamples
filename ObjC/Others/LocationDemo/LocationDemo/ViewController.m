//
//  ViewController.m
//  LocationDemo
//
//  Created by 郭伟林 on 2018/7/9.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRLocationManager.h"

@interface ViewController () <SRLocationManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SRLocationManager sharedManager].delegate = self;
    [[SRLocationManager sharedManager] requestAuthorization];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[SRLocationManager sharedManager] beginLocation];
}

- (void)locationManagerLocationSucceed {
    NSLog(@"currentLocationLongitude: %@", [SRLocationManager sharedManager].currentLocationLongitude);
    NSLog(@"currentLocationLatitude: %@", [SRLocationManager sharedManager].currentLocationLatitude);
    NSLog(@"currentLocationState: %@", [SRLocationManager sharedManager].currentLocationState);
    NSLog(@"currentLocationCity: %@", [SRLocationManager sharedManager].currentLocationCity);
    NSLog(@"currentLocationSubCity: %@", [SRLocationManager sharedManager].currentLocationSubCity);
}

@end
