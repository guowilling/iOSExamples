
#import "SRHTTPSessionManager.h"
#import "AFNetworking.h"
#import "SvUDIDTools.h"
#import "SRCacheManager.h"

static SRHTTPSessionManager *instance;

@interface SRHTTPSessionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation SRHTTPSessionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[self alloc] init];
            instance.showLog = YES;
        }
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _sessionManager.requestSerializer.timeoutInterval = 15.0;
        _sessionManager.responseSerializer.acceptableContentTypes = \
        [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"text/css", nil];
        [_sessionManager.requestSerializer setValue:[SvUDIDTools UDID] forHTTPHeaderField:@"imei"];
        [_sessionManager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
        
        [self startMonitorNetworkReachabilityStatus];
    }
    return self;
}

- (NSString *)userAgent {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [UIDevice currentDevice].model;
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]  objectAtIndex:0];;
    return [NSString stringWithFormat:@"EasyAuction %@ (%@; iOS %@; %@)", appVersion, deviceName, osVersion, language];
}

- (void)startMonitorNetworkReachabilityStatus {
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                _networkReachabilityStatus = SRNetworkReachabilityStatusUnknown;
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                _networkReachabilityStatus = SRNetworkReachabilityStatusNotReachable;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                _networkReachabilityStatus = SRNetworkReachabilityStatusReachableViaWWAN;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                _networkReachabilityStatus = SRNetworkReachabilityStatusReachableViaWiFi;
                break;
            }
        }
    }];
    [networkReachabilityManager startMonitoring];
}

- (BOOL)isCurrentNetworkReachable {
    if (self.networkReachabilityStatus == SRNetworkReachabilityStatusReachableViaWWAN || self.networkReachabilityStatus == SRNetworkReachabilityStatusReachableViaWiFi) {
        return YES;
    }
    return NO;
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
      cache:(void (^)(id cacheObject))cache
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    if (cache) {
        id cacheObject = [SRCacheManager cacheObjectForURLString:URLString parameters:parameters];
        if (cacheObject) {
            cache(cacheObject);
        }
    }
    [self.sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.showLog) {
            NSLog(@"***GET URLString: %@ \n***parameters: %@ \n***responseObject: %@", URLString, parameters, responseObject);
        }
        [SRCacheManager setObject:responseObject forURLString:URLString parameters:parameters];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.showLog) {
            NSLog(@"***GET URLString: %@ \n***parameters: %@ \n***error: %@", URLString, parameters, error);
        }
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
       cache:(void (^)(id cacheObject))cache
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    if (cache) {
        id cacheObject = [SRCacheManager cacheObjectForURLString:URLString parameters:parameters];
        if (cacheObject) {
            cache(cacheObject);
        }
    }
    [self.sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.showLog) {
            NSLog(@"***POST URLString: %@ \n***parameters: %@ \n***responseObject: %@", URLString, parameters, responseObject);
        }
        [SRCacheManager setObject:responseObject forURLString:URLString parameters:parameters];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.showLog) {
            NSLog(@"***POST URLString: %@ \n***parameters: %@ \n***error: %@", URLString, parameters, error);
        }
        if (failure) {
            failure(error);
        }
    }];
}

- (void)PUT:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    [self.sessionManager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)DELETE:(NSString *)URLString
    parameters:(NSDictionary *)parameters
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure
{
    [self.sessionManager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)downloadFile:(NSString *)URLString
           parameter:(NSDictionary *)patameter
           savedPath:(NSString *)savedPath
            progress:(void (^)(id downloadProgress, double progressValue))progress
          completion:(void (^)(NSString *filePath, NSError *error))completion
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        double progressValue = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        if (progress) {
            progress(downloadProgress, progressValue);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (savedPath) {
            return [NSURL fileURLWithPath:savedPath];
        } else {
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error && completion) {
            completion(nil, error);
            return;
        }
        if (completion) {
            completion(filePath.absoluteString, nil);
        }
    }];
    [downloadTask resume];
}

- (void)uploadFile:(NSString *)URLString
         parameter:(NSDictionary *)parameter
              data:(NSData *)fileData
         fieldName:(NSString *)fieldName
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    [self.sessionManager POST:URLString
                   parameters:parameter
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:fieldName fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) { } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadFile:(NSString *)URLString
          fromData:(NSData *)bodyData
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object, NSError *error))completion
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [self.sessionManager uploadTaskWithRequest:request
                                      fromData:bodyData
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          if (progress) {
                                              progress(uploadProgress);
                                          }
                                      } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (completion) {
                                              completion(responseObject,error);
                                          }
                                      }];
}

- (void)uploadFile:(NSString *)URLString
          fromFile:(NSURL *)fileURL
          progress:(void(^)(NSProgress *uploadProgress))progress
        completion:(void(^)(id object, NSError *error))completion
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [self.sessionManager uploadTaskWithRequest:request
                                      fromFile:fileURL
                                      progress:^(NSProgress * _Nonnull uploadProgress) {
                                          if (uploadProgress) {
                                              progress(uploadProgress);
                                          }
                                      } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (completion) {
                                              completion(responseObject,error);
                                          }
                                      }];
}

- (void)cancleTasks {
    [self.sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (NSString *)cacheKeyOfURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSData *parametersData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *parametersString = [[NSString alloc] initWithData:parametersData encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@%@", URLString, parametersString];
}

@end
