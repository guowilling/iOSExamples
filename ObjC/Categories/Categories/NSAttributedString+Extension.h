//
//  NSAttributedString+Extension.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (Extension)

+ (NSAttributedString *)attributedStringWithString:(NSString *)string
                                       shadowColor:(UIColor *)shadowColor
                                  shadowBlurRadius:(CGFloat)shadowBlurRadius
                                      shadowOffset:(CGSize)shadowOffset;


- (CGFloat)heightWithConstrainedWidth:(CGFloat)width;

@end
