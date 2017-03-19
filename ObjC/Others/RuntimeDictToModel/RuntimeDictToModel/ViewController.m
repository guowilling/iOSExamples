//
//  ViewController.m
//  RuntimeDictToModel
//
//  Created by 郭伟林 on 17/3/16.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+Runtime.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"properties: %@", [Person sr_objProperties]);
    
    NSDictionary *personDict = @{@"name": @"willing",
                                 @"age": @26,
                                 @"gender": @(YES),
                                 @"profession": @"iDev",
                                 @"others": @"No effects"};
    Person *person = [Person sr_objWithDict:personDict];
    NSLog(@"person: %@", person);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
