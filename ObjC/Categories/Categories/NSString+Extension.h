//
//  NSString+Extension.h
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 检验字符串是否有效
 */
- (BOOL)isAvailable;
+ (BOOL)isAvailable:(NSString *)aString;

/**
 *  Accroding the font get the string's best fit size
 *
 *  @param font The string font
 *
 *  @return The string's size
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  Accroding the font and the width get the string's best fit size
 *
 *  @param font The string font
 *  @param maxW The string max width
 *
 *  @return The string's size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxW;

#pragma mark - Encryption algorithm

- (NSString *)MD5Hash;

- (NSString *)urlEncodedString;
- (NSString *)urlDecodedString;

@end
