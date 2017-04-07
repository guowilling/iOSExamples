//
//  ViewController.m
//  DeviceInfomation
//
//  Created by 郭伟林 on 17/4/7.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "UIDevice-Hardware.h"
//#import "SystemServices.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSLog(@"platformString: %@", [currentDevice platformString]);
    NSLog(@"totalDiskSpace: %@", [currentDevice totalDiskSpace]);
    NSLog(@"freeDiskSpace: %@", [currentDevice freeDiskSpace]);
    
//    NSLog(@"uniqueID: %@", [SSUUID uniqueID]);
//    NSLog(@"deviceName: %@", [SSHardwareInfo deviceName]);
//    NSLog(@"systemName: %@", [SSHardwareInfo systemName]);
//    NSLog(@"systemVersion: %@", [SSHardwareInfo systemVersion]);
//    NSLog(@"systemDeviceTypeFormatted: %@", [SSHardwareInfo systemDeviceTypeFormatted:YES]);
//    NSLog(@"diskSpace: %@", [SSDiskInfo diskSpace]);
//    NSLog(@"usedDiskSpace: %@", [SSDiskInfo usedDiskSpace:YES]);
//    NSLog(@"freeDiskSpace: %@", [SSDiskInfo freeDiskSpace:YES]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
