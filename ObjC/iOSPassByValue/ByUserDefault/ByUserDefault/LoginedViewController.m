
#import "LoginedViewController.h"

#define SHeight self.view.frame.size.height
#define SWidth  self.view.frame.size.width

@interface LoginedViewController ()
{
    UITextField *_userNameText;
    UITextField *_passWordText;
}

@end

@implementation LoginedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userNameText = [self addTextField:100 leftViewName:@"账号:"];
    _userNameText.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    
    _passWordText = [self addTextField:CGRectGetMaxY(_userNameText.frame) + 20 leftViewName:@"密码:"];
    _passWordText.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"passWord"];
}

- (UITextField *)addTextField:(CGFloat )y leftViewName:(NSString *)name {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, y, SWidth - 40, 45)];
    textField.layer.borderWidth = 1.0f;
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth=YES;
    textField.leftView = label;
    textField.userInteractionEnabled = NO;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

@end
