//
//  ContactTool.h
//  SQL练习
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;

@interface ContactTool : NSObject

+ (void)saveContact:(Contact *)contact;

+ (NSArray *)contactWithSQL:(NSString *)sql;

+ (NSArray *)contacts;

@end
