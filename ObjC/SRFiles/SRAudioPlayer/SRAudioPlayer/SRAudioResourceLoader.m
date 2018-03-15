//
//  SRAudioResourceLoader.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioResourceLoader.h"
#import "SRAudioResourceDownloader.h"
#import "SRAudioFileManager.h"

@interface SRAudioResourceLoader () <SRAudioResourceDownloaderDelegate>

@property (nonatomic, strong) SRAudioResourceDownloader *downLoader;

@property (nonatomic, strong) NSMutableArray *loadingRequests;

@end

@implementation SRAudioResourceLoader

- (SRAudioResourceDownloader *)downLoader {
    
    if (!_downLoader) {
        _downLoader = [[SRAudioResourceDownloader alloc] init];
        _downLoader.delegate = self;
    }
    return _downLoader;
}

- (NSMutableArray *)loadingRequests {
    
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}

- (NSURL *)httpURL:(NSURL *)URL {
    
    NSURLComponents *compents = [NSURLComponents componentsWithString:URL.absoluteString];
    compents.scheme = @"http";
    return compents.URL;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    long long currentOffset = loadingRequest.dataRequest.currentOffset;
    if (requestOffset != currentOffset) {
        requestOffset = currentOffset;
    }
    
    NSURL *httpURL = [self httpURL:loadingRequest.request.URL];
    
    if ([SRAudioFileManager cacheFileExists:httpURL]) {
        [self handleLocalLoadingRequest:loadingRequest];
        return YES;
    }
    
    [self.loadingRequests addObject:loadingRequest];
    
    if (self.downLoader.loadedSize == 0) {
        [self.downLoader downLoadWithURL:httpURL offset:requestOffset];
        return YES;
    }
    if (requestOffset < self.downLoader.offset ||
        requestOffset > (self.downLoader.offset + self.downLoader.loadedSize + 500)) {
        [self.downLoader downLoadWithURL:httpURL offset:requestOffset];
        return YES;
    }
    
    [self handleAllLoadingRequest];
    
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    [self.loadingRequests removeObject:loadingRequest];
}

- (void)audioResourceDownloaderisDownLoading {
    
    [self handleAllLoadingRequest];
}

- (void)handleAllLoadingRequest {

    NSMutableArray *deleteRequests = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequests) {
        long long totalSize = self.downLoader.totalSize;
        loadingRequest.contentInformationRequest.contentLength = totalSize;
        NSString *contentType = self.downLoader.mimeType;
        loadingRequest.contentInformationRequest.contentType = contentType;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
        NSURL *URL = loadingRequest.request.URL;
        NSData *data = [NSData dataWithContentsOfFile:[SRAudioFileManager tmpFilePath:URL] options:NSDataReadingMappedIfSafe error:nil];
        if (!data) {
            data = [NSData dataWithContentsOfFile:[SRAudioFileManager cacheFilePath:URL] options:NSDataReadingMappedIfSafe error:nil];
        }
        
        long long requestOffset = loadingRequest.dataRequest.requestedOffset;
        long long currentOffset = loadingRequest.dataRequest.currentOffset;
        if (requestOffset != currentOffset) {
            requestOffset = currentOffset;
        }
        NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
        
        long long responseOffset = requestOffset - self.downLoader.offset;
        long long responseLength = MIN(self.downLoader.offset + self.downLoader.loadedSize - requestOffset, requestLength) ;
        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        [loadingRequest.dataRequest respondWithData:subData];
        if (requestLength == responseLength) {
            [loadingRequest finishLoading];
            [deleteRequests addObject:loadingRequest];
        }
    }
    
    [self.loadingRequests removeObjectsInArray:deleteRequests];
}

- (void)handleLocalLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSURL *URL = loadingRequest.request.URL;
    long long totalSize = [SRAudioFileManager cacheFileSize:URL];
    loadingRequest.contentInformationRequest.contentLength = totalSize;
    
    NSString *contentType = [SRAudioFileManager contentType:URL];
    loadingRequest.contentInformationRequest.contentType = contentType;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    NSData *data = [NSData dataWithContentsOfFile:[SRAudioFileManager cacheFilePath:URL] options:NSDataReadingMappedIfSafe error:nil];
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requestLength = loadingRequest.dataRequest.requestedLength;
    NSData *subData = [data subdataWithRange:NSMakeRange(requestOffset, requestLength)];
    [loadingRequest.dataRequest respondWithData:subData];
    
    [loadingRequest finishLoading];
}

@end
