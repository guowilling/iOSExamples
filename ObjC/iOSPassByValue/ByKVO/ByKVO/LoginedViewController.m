
#import "LoginedViewController.h"

#define SHeight self.view.frame.size.height
#define SWidth  self.view.frame.size.width

@interface LoginedViewController () <UITextFieldDelegate>
{
    UITextField *_userNameText;
    UITextField *_passWordText;
}

@end

@implementation LoginedViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userNameText = [self addTextField:100 leftViewName:@"账号:"];
    _userNameText.text = _userName;
    
    _passWordText = [self addTextField:CGRectGetMaxY(_userNameText.frame) + 20 leftViewName:@"密码:"];
    _passWordText.text = _passWord;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_userNameText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:_passWordText];
}

- (UITextField *)addTextField:(CGFloat )y leftViewName:(NSString *)name {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, y, SWidth - 40, 45)];
    textField.layer.borderWidth = 1.0f;
    textField.delegate = self;
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth=YES;
    textField.leftView = label;
    textField.userInteractionEnabled = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (_userNameText == notification.object) {
        self.userName = _userNameText.text; // _userName = _userNameText.text; Note this way will not callback KVO!
    }
    if (_passWordText == notification.object) {
        self.passWord = _passWordText.text;
    }
}

@end
