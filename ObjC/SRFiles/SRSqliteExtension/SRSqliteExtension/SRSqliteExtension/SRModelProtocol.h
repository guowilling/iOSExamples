//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRModelProtocol <NSObject>

@required
+ (NSString *)primaryKey;

@optional

+ (NSArray *)ignoreIvarsNames;

+ (NSDictionary *)newNameToOldNameDic;

@end
