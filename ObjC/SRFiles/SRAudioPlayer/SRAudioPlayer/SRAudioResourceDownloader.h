//
//  SRAudioResourceDownloader.h
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRAudioResourceDownloaderDelegate <NSObject>

- (void)audioResourceDownloaderIsDownLoading;

@end

@interface SRAudioResourceDownloader : NSObject

@property (nonatomic, weak) id<SRAudioResourceDownloaderDelegate> delegate;

@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) long long loadedSize;
@property (nonatomic, assign) long long offset;
@property (nonatomic, strong) NSString *mimeType;

- (void)downLoadWithURL:(NSURL *)URL offset:(long long)offset;

@end
