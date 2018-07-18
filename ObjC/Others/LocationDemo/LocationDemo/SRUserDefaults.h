//
//  SRUserDefaults.h
//  LocationDemo
//
//  Created by 郭伟林 on 2018/7/9.
//  Copyright © 2018年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRUserDefaults : NSObject

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)anBool forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

@end
