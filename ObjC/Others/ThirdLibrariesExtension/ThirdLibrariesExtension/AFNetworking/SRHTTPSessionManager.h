
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
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/// Download file
- (void)downloadFile:(NSString *)URLString
           parameter:(NSDictionary *)patameter
           savedPath:(NSString *)savedPath
            progress:(void (^)(id downloadProgress, double progressValue))progress
          completion:(void (^)(NSString *filePath, NSError *error))completion;

/// Upload file with POST
- (void)uploadFile:(NSString *)URLString
         parameter:(NSDictionary *)parameter
              data:(NSData *)fileData
         fieldName:(NSString *)fieldName
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

/// Upload task from data
- (void)uploadFile:(NSString *)URLString
          fromData:(NSData *)bodyData
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object, NSError *error))completion;

/// Upload task from URL
- (void)uploadFile:(NSString *)URLString
          fromFile:(NSURL *)fileURL
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object, NSError *error))completion;

@end
