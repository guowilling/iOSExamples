
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action norImage:(NSString *)image highImage:(NSString *)highImage;

@end
