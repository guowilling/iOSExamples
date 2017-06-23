//
//  SRAudioFileManager.h
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRAudioFileManager : NSObject

+ (NSString *)cacheFilePath:(NSURL *)URL;
+ (long long)cacheFileSize:(NSURL *)URL;
+ (BOOL)cacheFileExists:(NSURL *)URL;

+ (NSString *)tmpFilePath:(NSURL *)URL;
+ (long long)tmpFileSize:(NSURL *)URL;
+ (BOOL)tmpFileExists:(NSURL *)URL;

+ (NSString *)contentType:(NSURL *)URL;
+ (void)moveTmpPathToCachePath:(NSURL *)URL;
+ (void)clearTmpFile:(NSURL *)URL;

@end
