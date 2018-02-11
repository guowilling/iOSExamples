//
//  SRCacheManager.m
//  ThirdLibrariesExtension
//
//  Created by 郭伟林 on 2018/2/11.
//  Copyright © 2018年 SR. All rights reserved.
//

#import "SRCacheManager.h"
#import "YYCache.h"

static YYCache *yyCache;

@implementation SRCacheManager

+ (void)load {
    yyCache = [YYCache cacheWithName:NSStringFromClass(self)];
}

+ (void)setObject:(id)object forURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheObjectForURLString:URLString parameters:parameters];
    [yyCache setObject:object forKey:cacheKey];
}

+ (id)cacheObjectForURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheObjectForURLString:URLString parameters:parameters];
    return [yyCache objectForKey:cacheKey];
}

+ (CGFloat)totalCacheSize {
    return yyCache.diskCache.totalCost / 1024. / 1024.;
}

+ (void)removeAllCache {
    [yyCache.diskCache removeAllObjects];
}

+ (NSString *)cacheKeyOfURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSData *parametersData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *parametersString = [[NSString alloc] initWithData:parametersData encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@%@", URLString, parametersString];
}

@end
