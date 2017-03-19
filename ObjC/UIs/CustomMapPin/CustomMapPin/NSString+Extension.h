
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

#pragma mark - String size

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
- (CGSize)sizeWithFont:(UIFont *)font  maxWidth:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font maxHeight:(CGFloat)maxH;

@end
