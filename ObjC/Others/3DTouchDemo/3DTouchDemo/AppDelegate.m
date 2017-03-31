//
//  AppDelegate.m
//  3DTouchDemo
//
//  Created by 郭伟林 on 17/3/31.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self.window rootViewController];
    
    [self creatShortcutItems];
    
//    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
//    if (shortcutItem) {
//        NSString *message = nil;
//        if ([shortcutItem.type isEqualToString:@"com.willing.share"]) {
//            // 新启动 APP 分享
//        } else if ([shortcutItem.type isEqualToString:@"com.willing.search"]) {
//            // 新启动 APP 搜索
//        } else if ([shortcutItem.type isEqualToString:@"com.willing.location"]) {
//            // 新启动 APP 定位
//        }
//        return NO; // 返回 NO, 防止调用 application:performActionForShortcutItem:completionHandler:
//    }
    return YES;
}

- (void)creatShortcutItems {
    
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"com.willing.share"
                                                                        localizedTitle:@"分享"
                                                                     localizedSubtitle:@"分享副标题"
                                                                                  icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare]
                                                                              userInfo:nil];
    
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"com.willing.search"
                                                                        localizedTitle:@"搜索"
                                                                     localizedSubtitle:@"搜索副标题"
                                                                                  icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch]
                                                                              userInfo:nil];
    
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"com.willing.location"
                                                                        localizedTitle:@"定位"
                                                                     localizedSubtitle:@"定位副标题"
                                                                                  icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation]
                                                                              userInfo:nil];

    [UIApplication sharedApplication].shortcutItems = @[item1, item2, item3];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    NSString *message = nil;
    if ([shortcutItem.type isEqualToString:@"com.willing.share"]) {
        message = @"3D Touch 分享";
    } else if ([shortcutItem.type isEqualToString:@"com.willing.search"]) {
        message = @"3D Touch 搜索";
    } else if ([shortcutItem.type isEqualToString:@"com.willing.location"]) {
        message = @"3D Touch 定位";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    if (completionHandler) {
        completionHandler(YES);
    }
}

@end
