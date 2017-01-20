//
//  Singleton.h
//  BySingleton
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;

+ (instancetype)shared;

@end
