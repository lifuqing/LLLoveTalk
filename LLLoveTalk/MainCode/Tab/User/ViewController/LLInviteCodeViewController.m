//
//  LLInviteCodeViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/4.
//

#import "LLInviteCodeViewController.h"
#import "UIImage+LLTools.h"

@interface LLInviteCodeViewController ()
@property (nonatomic, strong) UITextField *inviteTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *skipButton;

@end

@implementation LLInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBackBarItemWithTitle:@"邀请码"];
    
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_invite")];
    userIcon.frame = CGRectMake(15, 20, 19, 19);
    
    _inviteTextField = [[UITextField alloc] initWithFrame:CGRectMake(48, userIcon.top + 2, self.view.width - 15 - 48, 17)];
    _inviteTextField.backgroundColor = [UIColor clearColor];
    _inviteTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inviteTextField.placeholder = @"请输入邀请码";
    _inviteTextField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
    _inviteTextField.keyboardType = UIKeyboardTypePhonePad;
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, userIcon.bottom+8, self.view.width - 30, 1)];
    line1.backgroundColor = LLTheme.lineColor;
    
    [self.view addSubview:userIcon];
    [self.view addSubview:_inviteTextField];
    [self.view addSubview:line1];
    
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.skipButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.inviteTextField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notify {
    _confirmButton.enabled = self.inviteTextField.text.length > 0;
}

- (void)confirmButtonActionClick:(UIButton *)sender {
    [self.view endEditing:NO];
    WEAKSELF();
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LLURL *llurl = [[LLURL alloc] initWithParser:@"InviteCodeParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params addEntriesFromDictionary:@{@"code":self.inviteTextField.text?:@""}];
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        [MBProgressHUD showMessage:model.errorMsg?:@"请求失败，请重试" inView:weakSelf.view autoHideTime:1];
    }];
}

- (void)skipButtonActionClick:(UIButton *)sender {
    [self commonPushBack];
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton ll_buttonWithFrame:CGRectMake(15, self.inviteTextField.bottom + 60, self.view.width - 30, 44) target:self title:@"确定" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 16] textColor:[UIColor whiteColor] selector:@selector(confirmButtonActionClick:)];
        [_confirmButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_confirmButton setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 6;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.enabled = NO;
        _confirmButton.adjustsImageWhenHighlighted = NO;
    }
    return _confirmButton;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton ll_buttonWithFrame:CGRectMake(15, self.confirmButton.bottom + 15, self.view.width - 30, 44) target:self title:@"跳过" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 16] textColor:[UIColor whiteColor] selector:@selector(skipButtonActionClick:)];
        [_skipButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_skipButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateNormal];
        _skipButton.layer.cornerRadius = 6;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.adjustsImageWhenHighlighted = NO;
    }
    return _skipButton;
}

@end
