//
//  ViewController.m
//  ConstantUUID
//
//  Created by 郭伟林 on 2018/8/30.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "ViewController.h"
#import <SAMKeychain/SAMKeychain.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *UUID = [SAMKeychain passwordForService:@"UUID" account:@"SR"];
    if (!UUID) {
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SAMKeychain setPassword:UUID forService:@"UUID" account:@"SR"];
        [SAMKeychain setAccessibilityType:kSecAttrAccessibleAlwaysThisDeviceOnly];
        NSLog(@"init UUID: %@", UUID);
    } else {
        NSLog(@"constant UUID: %@", UUID);
    }
    self.label.text = UUID;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
