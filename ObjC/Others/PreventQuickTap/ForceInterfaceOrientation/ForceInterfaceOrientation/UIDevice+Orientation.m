//
//  UIDevice+Orientation.m
//  ForceInterfaceOrientation
//
//  Created by Willing Guo on 2018/10/6.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "UIDevice+Orientation.h"

@implementation UIDevice (Orientation)

+ (void)switchInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
