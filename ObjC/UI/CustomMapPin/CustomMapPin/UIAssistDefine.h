
#import <sys/time.h>

#ifndef UIAssistDefine_h
#define UIAssistDefine_h

#pragma mark - COLOR

#define UICOLOR_FROM_HEX_ALPHA(RGBValue, Alpha) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:Alpha]

#define UICOLOR_FROM_HEX(RGBValue) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_RGBA(r,g,b,a)             [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define COLOR_RGB(r,g,b)                [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define COLOR_RANDOM                    COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)

#pragma mark - SCREENSIZE

#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_WIDTH            SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT           SCREEN_BOUNDS.size.height
#define SCREEN_ADJUST(Value)    ceilf(SCREEN_WIDTH * (Value) / 375.0)
#define SCREEN_MAX_LENGTH       (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH       (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0) // 320.f
#define IS_IPHONE6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0) // 375.f
#define IS_IPHONE6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0) // 414.f

#pragma mark - Other

#define IS_iOS10        [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0

#define kSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]

#endif /* UIAssistDefine_h */
