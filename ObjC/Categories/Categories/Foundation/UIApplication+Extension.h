//
//  UIApplication+Extension.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extension)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL    *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

@property (nonatomic, readonly) NSString *appBundleName;
@property (nonatomic, readonly) NSString *appBundleID;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuildVersion;

+ (UIViewController *)rootViewController;

@end
