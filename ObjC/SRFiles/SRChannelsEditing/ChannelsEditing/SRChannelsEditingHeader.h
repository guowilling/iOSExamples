
#import <Foundation/Foundation.h>
#import "UIView+SRFrame.h"
#import "UIButton+SRSugar.h"

#define SR_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SR_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SR_STATUS_BAR_HEIGHT     (SR_SCREEN_HEIGHT == 812 ? 44 : 20)
#define SR_NAVIGATION_BAR_HEIGHT (SR_SCREEN_HEIGHT == 812 ? 88 : 64)
#define SR_TAB_BAR_HEIGHT        (SR_SCREEN_HEIGHT == 812 ? 83 : 49)
