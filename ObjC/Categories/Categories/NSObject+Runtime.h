//
//  NSObject+Runtime.h
//  SRCategory
//
//  Created by 郭伟林 on 17/4/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (NSString *)fetchClassName:(Class)class;

+ (NSArray *)fetchIvarList:(Class)class;

/** 包括公有和私有属性即定义在扩展中的属性 */
+ (NSArray *)fetchPropertyList:(Class)class;

/** 不包括类方法 */
+ (NSArray *)fetchMethodList:(Class)class;

+ (NSArray *)fetchProtocolList:(Class)class;

+ (void)addMethodToClass:(Class)class methodName:(SEL)methodName methodImp:(SEL)methodImp;
    
@end
