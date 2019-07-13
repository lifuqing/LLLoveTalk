//
//  LLLoginViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLLoginViewController.h"
#import "UIButton+LLTools.h"
#import "UIImage+LLTools.h"
#import "LLInviteCodeViewController.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
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
                if ([LLUser sharedInstance].isnew) {
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        LLInviteCodeViewController *vc = [[LLInviteCodeViewController alloc] init];
                        [LLNav pushViewController:vc animated:YES];
                    }];
                }
                else
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
                self.sendCodeButton.enabled = YES;
                self.sendCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%.2d", seconds] forState:UIControlStateNormal];
                self.sendCodeButton.enabled = NO;
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom + 56, self.view.width, 185 + 56)];
        
        UIImageView *slogon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_slogon")];
        slogon.center = CGPointMake(_contentView.width/2.0, 28);
        
        CGFloat topSpcace = 60;
        
        UIImageView *userIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_user")];
        userIcon.frame = CGRectMake(15, slogon.bottom + topSpcace, 18, 19);
        
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(48, userIcon.top + 2, _contentView.width - 15 - 48, 17)];
        _phoneTextField.backgroundColor = [UIColor clearColor];
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"请输入手机号码";
        _phoneTextField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, userIcon.bottom+8, _contentView.width - 30, 1)];
        line1.backgroundColor = LLTheme.lineColor;
        
        
        CGFloat sendCodeBtnWidth = 100;
        
        UIImageView *codeIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_code")];
        codeIcon.frame = CGRectMake(15, line1.bottom + 34, 18, 19);
        
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneTextField.left, line1.bottom + 36, _contentView.width - 48 - sendCodeBtnWidth - 15 - 10, 17)];
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, codeIcon.bottom+8, _contentView.width - 30, 1)];
        line2.backgroundColor = LLTheme.lineColor;
        
        _sendCodeButton = [UIButton ll_buttonWithFrame:CGRectMake(_contentView.width - 15 - sendCodeBtnWidth, line1.bottom + 29, sendCodeBtnWidth, 30) target:self title:@"发送验证码" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 16] textColor:[UIColor whiteColor] selector:@selector(sendCodeButtonActionClick:)];
        [_sendCodeButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_sendCodeButton setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
        _sendCodeButton.layer.cornerRadius = 6;
        _sendCodeButton.layer.masksToBounds = YES;
        _sendCodeButton.enabled = NO;
        _sendCodeButton.adjustsImageWhenHighlighted = NO;
        
        
        [_contentView addSubview:slogon];
        [_contentView addSubview:userIcon];
        [_contentView addSubview:_phoneTextField];
        [_contentView addSubview:line1];
        [_contentView addSubview:codeIcon];
        [_contentView addSubview:_codeTextField];
        [_contentView addSubview:line2];
        [_contentView addSubview:_sendCodeButton];
    }
    return _contentView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton ll_buttonWithFrame:CGRectMake(15, _contentView.bottom, self.view.width - 30, 44) target:self title:@"登录" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 16] textColor:[UIColor whiteColor] selector:@selector(loginButtonActionClick:)];
        [_loginButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_loginButton setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 6;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.enabled = NO;
        _loginButton.adjustsImageWhenHighlighted = NO;
    }
    return _loginButton;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:NO];
}
@end
