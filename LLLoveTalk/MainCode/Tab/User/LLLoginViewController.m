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
    self.view.backgroundColor = [UIColor blueColor];
    [self addBackBarItemWithTitle:@"登 录"];
//    [self.view addSubview:self.contentView];
//    [self.view addSubview:self.loginButton];
}

- (void)sendCodeButtonActionClick:(UIButton *)sender {
    
}
- (void)loginButtonActionClick:(UIButton *)sender {
    
}
#pragma mark - lazyloading
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.view.width, 114)];
        
        
        UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 47)];
        bg1.backgroundColor = [UIColor purpleColor];
        UIImageView *userIcon = [[UIImageView alloc] initWithImage:LLImage(@"")];
        userIcon.contentMode = UIViewContentModeCenter;
        userIcon.backgroundColor = [UIColor whiteColor];
        userIcon.layer.cornerRadius = 6;
        userIcon.layer.masksToBounds = YES;
        userIcon.frame = CGRectMake(15, 3.5, 40, 40);
        _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 3.5, _contentView.width - 5 - userIcon.right - 15, 40)];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.layer.cornerRadius = 6;
        _phoneTextField.layer.masksToBounds = YES;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"请输入手机号码";
        
        [bg1 addSubview:userIcon];
        [bg1 addSubview:_phoneTextField];
        
        
        UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, bg1.bottom + 20, _contentView.width, 47)];
        bg2.backgroundColor = [UIColor purpleColor];
        UIImageView *codeIcon = [[UIImageView alloc] initWithImage:LLImage(@"")];
        codeIcon.contentMode = UIViewContentModeCenter;
        codeIcon.backgroundColor = [UIColor whiteColor];
        codeIcon.layer.cornerRadius = 6;
        codeIcon.layer.masksToBounds = YES;
        codeIcon.frame = CGRectMake(15, 3.5, 40, 40);
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 3.5, _contentView.width - 5 - userIcon.right - 15, 40)];
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.layer.cornerRadius = 6;
        _codeTextField.layer.masksToBounds = YES;
        _codeTextField.placeholder = @"请输入验证码";
        
        _sendCodeButton = [UIButton buttonWithFrame:CGRectMake(bg2.width - 20, (bg2.height - 50)/2.0, 97, 25) target:self title:@"发送验证码" font:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor] selector:@selector(sendCodeButtonActionClick:)];
        _sendCodeButton.backgroundColor = LLTheme.mainColor;
        _sendCodeButton.layer.cornerRadius = 6;
        _sendCodeButton.layer.masksToBounds = YES;
        
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
        _loginButton = [UIButton buttonWithFrame:CGRectMake(15, _contentView.bottom + 37, self.view.width - 30, 37) target:self title:@"登 录" font:[UIFont systemFontOfSize:22] textColor:[UIColor whiteColor] selector:@selector(loginButtonActionClick:)];
        _loginButton.backgroundColor = LLTheme.mainColor;
        _loginButton.layer.cornerRadius = 6;
        _loginButton.layer.masksToBounds = YES;
    }
    return _loginButton;
}
@end
