//
//  SRAudioFileManager.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioFileManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()

@implementation SRAudioFileManager

+ (NSString *)cacheFilePath:(NSURL *)URL {
    
    return [kCachePath stringByAppendingPathComponent:URL.lastPathComponent];
}


+ (long long)cacheFileSize:(NSURL *)URL {
    
    if (![self cacheFileExists:URL]) {
        return 0;
    }
    NSString *path = [self cacheFilePath:URL];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}

+ (BOOL)cacheFileExists:(NSURL *)URL {
    
    NSString *path = [self cacheFilePath:URL];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)tmpFilePath:(NSURL *)URL {
    
    return [kTmpPath stringByAppendingPathComponent:URL.lastPathComponent];
}

+ (long long)tmpFileSize:(NSURL *)URL {

    if (![self tmpFileExists:URL]) {
        return 0;
    }
    NSString *path = [self tmpFilePath:URL];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}


+ (BOOL)tmpFileExists:(NSURL *)URL {
    
    NSString *path = [self tmpFilePath:URL];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)contentType:(NSURL *)URL {
    
    NSString *path = [self cacheFilePath:URL];
    NSString *fileExtension = path.pathExtension;
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    return contentType;
}

+ (void)moveTmpPathToCachePath:(NSURL *)URL {
    
    NSString *tmpPath = [self tmpFilePath:URL];
    NSString *cachePath = [self cacheFilePath:URL];
    [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:cachePath error:nil];
}

+ (void)clearTmpFile:(NSURL *)URL {
    
    NSString *tmpPath = [self tmpFilePath:URL];
    BOOL isDirectory = YES;
    BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDirectory];
    if (isEx && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
    
}

@end
