
#import "EnrollViewController.h"

#define SHeight self.view.frame.size.height
#define SWidth  self.view.frame.size.width

@interface EnrollViewController () <UITextFieldDelegate>
{
    UITextField *_userNameText;
    UITextField *_passWordText;
}

@end

@implementation EnrollViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"注册";
    
    _userNameText = [self addTextField:100 leftViewName:@"账号:"];
    _passWordText = [self addTextField:CGRectGetMaxY(_userNameText.frame) + 20 leftViewName:@"密码:"];
    
    [self addButtonWithRect:CGRectMake((SWidth - 100) * 0.5, CGRectGetMaxY(_passWordText.frame) + 50, 100, 40) withTitle:@"确定"];
}

- (UITextField *)addTextField:(CGFloat)y leftViewName:(NSString *)name {
    
    UITextField *textField=[[UITextField alloc]initWithFrame:CGRectMake(20, y, SWidth - 40, 40)];
    textField.layer.borderWidth = 1.0f;
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    textField.leftView = label;
    textField.delegate = self;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (UIButton *)addButtonWithRect:(CGRect)frame withTitle:(NSString *)name {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:frame];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)buttonAction:(UIButton *)button {
    
    [self textResignFirstResponder];
    
    NSDictionary *userInfo = @{@"username": _userNameText.text, @"password": _passWordText.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnrollSuccess" object:nil userInfo:userInfo];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (void)textResignFirstResponder {
    
    [_userNameText resignFirstResponder];
    [_passWordText resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self textResignFirstResponder];
}

@end
