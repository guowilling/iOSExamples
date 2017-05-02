//
//  UILabel+RichText.m
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UILabel+RichText.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation UILabel (RichText)

#pragma mark - Associate Object

- (CGFloat)characterColumnSpace {
    
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCharacterColumnSpace:(CGFloat)characterColumnSpace {
    
    objc_setAssociatedObject(self, @selector(characterColumnSpace), @(characterColumnSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)characterLineSpace {
    
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCharacterLineSpace:(CGFloat)characterLineSpace {
    
    objc_setAssociatedObject(self, @selector(characterLineSpace), @(characterLineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)keywords {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywords:(NSString *)keywords {
    
    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)keywordsFont {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsFont:(UIFont *)keywordsFont {
    
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)keywordsColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsColor:(UIColor *)keywordsColor {
    
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)underlineString {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineString:(NSString *)underlineString {
    
    objc_setAssociatedObject(self, @selector(underlineString), underlineString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)underlineColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    
    objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Methods

- (void)applyRichEffect {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
    
    if (self.characterLineSpace > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        paragraphStyle.lineSpacing = self.characterLineSpace;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    if (self.characterColumnSpace > 0) {
        long number = self.characterColumnSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, attributedString.length)];
        CFRelease(num);
    }
    
    if (self.keywords) {
        NSRange range = [self.text rangeOfString:self.keywords];
        if (self.keywordsFont) {
            [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:range];
        }
        if (self.keywordsColor) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:range];
        }
    }
    
    if (self.underlineString) {
        NSRange range = [self.text rangeOfString:self.underlineString];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        if (self.underlineColor) {
            [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:range];
        }
    }
    
    self.attributedText = attributedString;
}

- (CGSize)getRectWithMaxWidth:(CGFloat)maxWidth {
    
    // 如果设置了 paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail
    // 这种方式高度计算不准确
//    CGRect rect = [self.attributedText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
//                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                    context:nil];
    
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize expectSize = [self sizeThatFits:maxSize];
    return expectSize;
}

@end
