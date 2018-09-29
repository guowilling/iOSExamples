
#import <UIKit/UIKit.h>

@interface UIButton (SRSugar)

+ (UIButton * (^)(UIButtonType))button;

- (UIButton * (^)(UIColor *backgroundColor))backgroundColor;

- (UIButton * (^)(NSString *title, UIControlState status))title;

- (UIButton * (^)(UIColor *titleColor))titleColor;

- (UIButton * (^)(UIImage *image, UIControlState state))image;

- (UIButton * (^)(UIImage *backgroundImage, UIControlState state))backgroundImage;

- (UIButton * (^)(UIColor *borderColor, CGFloat borderWidth))border;

@end
