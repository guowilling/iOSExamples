//
//  UIDevice+Extension.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)

// Device system version (e.g. 8.1)
+ (float)systemVersion;

// Whether the device is iPad/iPad mini/iPad pro.
@property (nonatomic, readonly) BOOL isPad;

// Wherher the device can make phone calls.
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

@end
