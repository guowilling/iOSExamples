
#import <UIKit/UIKit.h>

@interface EnrollViewController : UIViewController

@property (nonatomic, copy) void (^enrollSuccess)(NSString *username, NSString *password);

@end
