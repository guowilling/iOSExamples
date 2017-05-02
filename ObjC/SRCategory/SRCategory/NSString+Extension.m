//
//  NSString+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/11/24.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (BOOL)isAvailable {
    
    if (self && ![self isKindOfClass:NSNull.class] && self.length > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isAvailable:(NSString *)aString {
    
    if (aString && ![aString isKindOfClass:NSNull.class] && aString.length > 0) {
        return YES;
    }
    return NO;
}

- (CGSize)sizeWithFont:(UIFont *)font {
    
    return [self sizeWithFont:font maxWidth:MAXFLOAT];
}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxW {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSString *)MD5Hash {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG)[self length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7],
                   digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];
    return s;
}

- (NSString *)urlEncodedString {
    
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    size_t sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString *)urlDecodedString {
    
    return [self stringByRemovingPercentEncoding];
    //return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
