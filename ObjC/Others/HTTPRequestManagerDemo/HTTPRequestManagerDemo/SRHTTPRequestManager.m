//
//  SRHTTPRequestManager.m
//  HTTPRequestManagerDemo
//
//  Created by 郭伟林 on 2018/7/18.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRHTTPRequestManager.h"

@implementation SRHTTPRequestManager

+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableString *URLStringM = [[NSMutableString alloc] initWithString:URLString];
    if ([parameters allKeys]) {
        [URLStringM appendString:@"?"];
        for (NSString * key in parameters) {
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [URLStringM appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
        URLString = [[URLStringM substringToIndex:URLStringM.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error, response);
            } else {
                NSDictionary *respObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(respObject, response);
            }
        });
    }];
    [dataTask resume];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    requestM.HTTPMethod = @"POST";
    NSString *keyValueFormat;
    NSMutableString *parametersStringM = [NSMutableString string];
    NSEnumerator *keyEnum = [parameters keyEnumerator];
    NSString *key = nil;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [parameters valueForKey:key]];
        [parametersStringM appendString:keyValueFormat];
    }
    if (parametersStringM.length > 0) {
        NSString *parametersString = [parametersStringM substringToIndex:parametersStringM.length - 1];
        requestM.HTTPBody = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failure(error, response);
            } else {
                NSDictionary *respObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(respObject, response);
            }
        });
    }];
    [dataTask resume];
}

@end
