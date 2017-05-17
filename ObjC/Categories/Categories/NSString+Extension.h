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

- (BOOL)isAvailable;
+ (BOOL)isAvailable:(NSString *)aString;

/**
 Accroding the font to get best fit size of the string.
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 Accroding the font and max width to get best fit size of the string.
 */
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;

- (NSString *)MD5Hash;

- (NSString *)urlEncodedString;
- (NSString *)urlDecodedString;

@end
