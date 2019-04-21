//
//  LLLoginViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLLoginViewController.h"
#import "UIButton+LLTools.h"

@interface LLLoginViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@end

@implementation LLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopCloseWithTitle:@"登录"];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.loginButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notify {
    _sendCodeButton.enabled = _phoneTextField.text.length > 0;
    _loginButton.enabled = (_phoneTextField.text.length > 0 && _codeTextField.text.length > 0);
}

- (void)sendCodeButtonActionClick:(UIButton *)sender {
    sender.enabled = NO;
    WEAKSELF();
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LLUser sharedInstance] sendCodeWithPhone:_phoneTextField.text completion:^(BOOL success, NSString * _Nullable errorMsg) {
        sender.enabled = YES;
        STRONGSELF();
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [MBProgressHUD showMessage:errorMsg inView:strongSelf.view autoHideTime:1];
        if (success) {
            [strongSelf.codeTextField becomeFirstResponder];
            [strongSelf openCountdown];
        }
    }];
}

- (void)loginButtonActionClick:(UIButton *)sender {
    [self.view endEditing:NO];
    sender.enabled = NO;
    WEAKSELF();
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LLUser sharedInstance] loginWithPhone:_phoneTextField.text code:_codeTextField.text completion:^(BOOL success, NSString * _Nullable errorMsg) {
        sender.enabled = YES;
        STRONGSELF();
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [MBProgressHUD showMessage:errorMsg inView:strongSelf.view autoHideTime:1 interactionEnabled:!success completion:^{
            if (success) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.sendCodeButton setBackgroundColor:LLTheme.mainColor];
                self.sendCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.sendCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.sendCodeButton setBackgroundColor:[UIColor grayColor]];
                
                self.sendCodeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - lazyloading
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom + 25, self.view.width, 114)];
        
        
        UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 47)];
        bg1.backgroundColor = LLTheme.auxiliaryColor;
        UIImageView *userIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_user")];
        userIcon.frame = CGRectMake(15, 3.5, 40, 40);
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(userIcon.right + 5, 3.5, _contentView.width - 5 - userIcon.right - 15, 40)];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.layer.cornerRadius = 6;
        _phoneTextField.layer.masksToBounds = YES;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"请输入手机号码";
        _phoneTextField.font = [UIFont systemFontOfSize:16];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.leftView = leftView;
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    
        
        [bg1 addSubview:userIcon];
        [bg1 addSubview:_phoneTextField];
        
        
        UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, bg1.bottom + 20, _contentView.width, 47)];
        bg2.backgroundColor = LLTheme.auxiliaryColor;
        UIImageView *codeIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_code")];
        codeIcon.frame = CGRectMake(15, 3.5, 40, 40);
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(codeIcon.right + 5, 3.5, _contentView.width - 5 - codeIcon.right - 15, 40)];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.layer.cornerRadius = 6;
        _codeTextField.layer.masksToBounds = YES;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = [UIFont systemFontOfSize:16];
        UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.leftView = leftView2;
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;

        
        _sendCodeButton = [UIButton ll_buttonWithFrame:CGRectMake(bg2.width - 20 - 97, (bg2.height - 25)/2.0, 97, 25) target:self title:@"发送验证码" font:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] selector:@selector(sendCodeButtonActionClick:)];
        [_sendCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _sendCodeButton.backgroundColor = LLTheme.mainColor;
        _sendCodeButton.layer.cornerRadius = 6;
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.enabled = NO;
        
        [bg2 addSubview:codeIcon];
        [bg2 addSubview:_codeTextField];
        [bg2 addSubview:_sendCodeButton];
        
        [_contentView addSubview:bg1];
        [_contentView addSubview:bg2];
    }
    return _contentView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton ll_buttonWithFrame:CGRectMake(15, _contentView.bottom + 37, self.view.width - 30, 37) target:self title:@"登录" font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor] selector:@selector(loginButtonActionClick:)];
        [_loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _loginButton.backgroundColor = LLTheme.mainColor;
        _loginButton.layer.cornerRadius = 6;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.enabled = NO;
    }
    return _loginButton;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:NO];
}
@end
