
#import <UIKit/UIKit.h>

@protocol EnrollViewControllerDelegate <NSObject>

- (void)enrollWithUserName:(NSString *)userName password:(NSString *)password;

@end

@interface EnrollViewController : UIViewController

@property (nonatomic, weak) id<EnrollViewControllerDelegate> delegate;

@end
