//
//  JavaScriptCoreExtension.m
//  OCAndJSInteraction
//
//  Created by Willing Guo on 16/12/1.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "JavaScriptCoreExtension.h"

@implementation JavaScriptCoreExtension

- (NSString *)getAppVersion {
    
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];;
}

- (NSInteger)getSumWithNumber1:(id)num1 number2:(id)num2 number3:(id)num3 {
    
    NSInteger result = [num1 integerValue] + [num2 integerValue] + [num3 integerValue];
    return result;
}

@end
