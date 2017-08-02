//
//  AppDelegate.m
//  
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "AppDelegate.h"
#import "EditionFeaturesViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BOOL shouldShow = [EditionFeaturesViewController shouldShowEditionFeatures];
    shouldShow = YES; // set YES for test
    if (shouldShow) {
        NSArray *imageNames = @[@"editionfeature1.jpg", @"editionfeature2.jpg", @"editionfeature3.jpg", @"editionfeature4.jpg"];
        EditionFeaturesViewController *featuresVC = [EditionFeaturesViewController editionFeaturesWithImageNames:imageNames switchRootVCBtnImageName:@"start_huanshi_AR_normal"  rootViewController:[ViewController new]];
        featuresVC.hideSkipButton = NO; // show skip Button
        self.window.rootViewController = featuresVC;
    } else {
        self.window.rootViewController = [ViewController new];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end