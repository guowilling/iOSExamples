
#ifndef UIAssistDefine_h
#define UIAssistDefine_h

#import "YXGlobalDefine.h"

#pragma mark - GCD

#define kGlobalQueue  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kMainQueue    dispatch_get_main_queue()

#pragma mark - COLOR

#define UICOLOR_HEX_ALPHA(RGBValue, Alpha) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:Alpha]

#define UICOLOR_HEX(RGBValue) [UIColor \
colorWithRed:((float)((RGBValue & 0xFF0000) >> 16))/255.0 \
green:((float)((RGBValue & 0xFF00) >> 8))/255.0 \
blue:((float)(RGBValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_RGBA(r,g,b,a)  [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define COLOR_RGB(r,g,b)     COLOR_RGBA(r,g,b,1.0)
#define COLOR_RANDOM         COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)

#define COLOR_THEME [UIColor colorWithRed:0.27 green:0.59 blue:0.81 alpha:1.00]

#define COLOR_DIVIDERLIN             COLOR_RGBA(240, 240, 240, 1.0)
#define COLOR_LIGHTORANGE            COLOR_RGBA(255, 165, 34, 1.0)

#define COLOR_REDPACKET_BUTTONBACK   COLOR_RGBA(235, 198, 134, 1.0)
#define COLOR_REDPACKET_BUTTONTITLE  COLOR_RGBA(97, 79, 49, 1.0)
#define COLOR_REDPACKET_BACKGROUND   COLOR_RGBA(248, 243, 232, 1.0)

#define COLOR_BACKGROUND_GRAY        UICOLOR_HEX_ALPHA(0xF5F5F5, 1.0)
#define COLOR_BUTTON_HIGHLIGHTED     UICOLOR_HEX_ALPHA(0xF76B1E, 0.15)
#define COLOR_TEXT_GRAY              UICOLOR_HEX_ALPHA(0x9B9B9B, 1.0)
#define COLOR_TEXT_ORANGE            UICOLOR_HEX_ALPHA(0xF76B1E, 1.0)
#define COLOR_TEXT_MILDBLACK         UICOLOR_HEX_ALPHA(0x4A4A4A, 1.0)

#pragma mark - FONT

#define BOLD_SYSTEMFONT(size) [UIFont boldSystemFontOfSize:size]
#define SYSTEM_FONT(size)     [UIFont systemFontOfSize:size]
#define FONT(name, size)      [UIFont fontWithName:(name) size:(size)]

#pragma mark - SCREEN_SIZE

#define IS_IPAD    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE40_INCH   (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)  // 320 * 568
#define IS_IPHONE47_INCH   (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)  // 375 * 667
#define IS_IPHONE55_INCH   (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)  // 414 * 736
#define IS_IPHONE58_INCH   (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)  // 375 * 812
#define SCREEN_MAX_LENGTH  (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH  (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH    SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT   SCREEN_BOUNDS.size.height
#define SCREEN_ADJUST_WIDTH(Value)   ceilf(SCREEN_WIDTH * (Value) / 375.0)
#define SCREEN_ADJUST_HEIGHT(Value)  ceilf(SCREEN_HEIGHT * (Value) / 667.0)

#define YXNavBarHeight     (IS_IPHONE58_INCH ? 88.0 : 64.0)
#define YXTabBarHeight     (IS_IPHONE58_INCH ? 83.0 : 49.0)
#define YXStatusBarHeight  (IS_IPHONE58_INCH ? 44.0 : 20.0)
#define YXBottomHeight  (IS_IPHONE58_INCH ? 30.0 : 0.0)

#endif
