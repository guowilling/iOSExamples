//
//  UIColor+Extension.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 *  16进制字符串对应的RGB颜色
 *
 *  @param hexString 16进制字符串
 *
 *  @return RGB颜色
 */
+ (instancetype)colorWithHexString:(NSString *)hexString;

+ (instancetype)colorWithHex:(u_int32_t)hex;

@end
