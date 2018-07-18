//
//  SRHTTPRequestManager.h
//  HTTPRequestManagerDemo
//
//  Created by 郭伟林 on 2018/7/18.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary *respObject, NSURLResponse *response);
typedef void (^FailureBlock)(NSError *error, NSURLResponse *response);

@interface SRHTTPRequestManager : NSObject

+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
