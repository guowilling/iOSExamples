//
//  SRNetworkingManager.h
//
//  Created by 郭伟林 on 16/7/11.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SRNetworkReachabilityStatus) {
    SRNetworkReachabilityStatusUnknown          = -1,
    SRNetworkReachabilityStatusNotReachable     = 0,
    SRNetworkReachabilityStatusReachableViaWWAN = 1,
    SRNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface SRHTTPSessionManager : NSObject

@property (nonatomic, assign) SRNetworkReachabilityStatus networkReachabilityStatus;

+ (instancetype)sharedManager;

- (void)startMonitorReachabilityStatus;

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure;

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;

/** Download file */
- (void)downloadFile:(NSString *)URLString
           parameter:(NSDictionary *)patameter
           savedPath:(NSString *)savedPath
            progress:(void (^)(id downloadProgress, double progressValue))progress
            complete:(void (^)(NSData *data, NSError *error))complete;

/** Upload file with POST */
- (void)POST:(NSString *)URLString
   parameter:(NSDictionary *)parameter
        data:(NSData *)fileData
   fieldName:(NSString *)fieldName
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;

/** Upload task from Data */
- (void)uploadData:(NSString *)URLString
          fromData:(NSData *)fromData
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object,NSError *error))completion;

/** Upload task from URL */
- (void)uploadData:(NSString *)URLString
          fromFile:(NSURL *)fromFileURL
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object,NSError *error))completion;

@end
