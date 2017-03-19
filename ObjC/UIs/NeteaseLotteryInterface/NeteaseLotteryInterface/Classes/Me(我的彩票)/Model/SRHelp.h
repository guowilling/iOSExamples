//
//  SRHelp.h
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRHelp : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *html;
@property (nonatomic, copy) NSString *tag;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)helpWithDict:(NSDictionary *)dict;
+ (NSArray *)helps;

@end
