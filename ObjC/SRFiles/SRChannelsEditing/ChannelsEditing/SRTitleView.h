
#import <UIKit/UIKit.h>

@interface SRTitleView : UIView

@property (nonatomic, copy) void(^editBtnSelectedDidChangeBlock)(BOOL isSelected);

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle needEditBtn:(BOOL)needEditBtn;

@end
