//
//  NSString+Emoji.h
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/**
 十六进制编码的数字转为 emoji 字符
 
 @param intCode 十六进制数字
 @return emoji 字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 十六进制编码的数字转为 emoji 字符
 
 @param stringCode 十六进制数字字符串
 @return emoji 字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;

- (NSString *)emoji;

/**
 是否为 emoji 字符
 */
- (BOOL)isEmoji;

@end
