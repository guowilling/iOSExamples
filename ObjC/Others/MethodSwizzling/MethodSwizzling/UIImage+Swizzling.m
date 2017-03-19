//
//  UIImage+Swizzling.m
//  MethodSwizzling
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UIImage+Swizzling.h"
#import <objc/runtime.h>

@implementation UIImage (Swizzling)

+ (void)load {
    
    Method imageNamed = class_getClassMethod(self, @selector(imageNamed:));
    Method hook_imageNamed = class_getClassMethod(self, @selector(hook_imageNamed:));
    method_exchangeImplementations(hook_imageNamed, imageNamed);
}

+ (UIImage *)hook_imageNamed:(NSString *)name {
    
    BOOL iOS7 = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
    UIImage *image = nil;
    if (iOS7) {
        image = [UIImage hook_imageNamed:[name stringByAppendingString:@"_iOS7"]];
    } else {
        image = [UIImage hook_imageNamed:name];
    }
    return image;
}

@end
