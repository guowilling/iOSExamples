//
//  SRCacheManager.h
//  ThirdLibrariesExtension
//
//  Created by 郭伟林 on 2018/2/11.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRCacheManager : NSObject

+ (void)setObject:(id)object forURLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

+ (id)cacheObjectForURLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

+ (CGFloat)totalCacheSize; // in MByte

+ (void)removeAllCache;

@end
