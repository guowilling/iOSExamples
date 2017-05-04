//
//  NSString+RegExp.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegExp)

/**
 *  正则匹配用户身份证号15或18位
 */
+ (BOOL)checkUserIdCard:(NSString *)card;

/**
 *  正则匹配用户密码6-18位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *)password;

/**
 *  正则匹配URL
 */
+ (BOOL)checkURL:(NSString *)URL;

/**
 *  正则匹配用户 Email
 */
+ (BOOL)checkEmail:(NSString *)email;

/**
 *  正则匹配用户 qq
 */
+ (BOOL)checkTencentQQ:(NSString *)qq;

/**
 *  正则匹配用户昵称3-20位的中文或英文
 */
+ (BOOL)checkNickname:(NSString *)nickname;

/**
 *  正则匹配短信验证码
 */
+ (BOOL)checkSMS:(NSString *)sms;

/**
 *  正则匹配手机号
 */
+ (BOOL)checkTelNumber:(NSString *)telNumber;

@end
