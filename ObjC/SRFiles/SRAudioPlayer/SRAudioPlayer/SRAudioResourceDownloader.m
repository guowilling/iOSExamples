//
//  SRAudioResourceDownloader.m
//  SRAudioPlayerDemo
//
//  Created by Willing Guo on 2017/6/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRAudioResourceDownloader.h"
#import "SRAudioFileManager.h"

@interface SRAudioResourceDownloader () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, strong) NSURL *assetURL;

@end

@implementation SRAudioResourceDownloader

- (NSURLSession *)session {
    
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (void)downLoadWithURL:(NSURL *)URL offset:(long long)offset {
    
    [self cancelAndClean];
    self.assetURL = URL;
    self.offset = offset;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

- (void)cancelAndClean {
    
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [SRAudioFileManager clearTmpFile:self.assetURL];
    self.loadedSize = 0;
}

#pragma mark - NSURLSessionDataDelegate {

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    self.totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }

    self.mimeType = response.MIMEType;
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[SRAudioFileManager tmpFilePath:self.assetURL] append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    self.loadedSize += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(audioResourceDownloaderisDownLoading)]) {
        [self.delegate audioResourceDownloaderisDownLoading];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"didCompleteWithError error: %@", error);
        return;
    }
    if ([SRAudioFileManager tmpFileSize:self.assetURL] == self.totalSize) {
        [SRAudioFileManager moveTmpPathToCachePath:self.assetURL];
    }
}

@end
