
#import <UIKit/UIKit.h>

@class SRLeftMenu;

@protocol SRLeftMenuDelegate <NSObject>

@optional
- (void)leftMenu:(SRLeftMenu *)menu didSelectedButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface SRLeftMenu : UIView

@property (nonatomic, weak) id<SRLeftMenuDelegate> delegate;

@end
