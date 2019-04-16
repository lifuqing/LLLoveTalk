//
//  LLEditInfoViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/15.
//

#import "LLEditInfoViewController.h"
@interface LLEditInfoViewController ()
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UIButton *editButton;
@end

@implementation LLEditInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarItemWithTitle:@"个人信息"];
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.view.width, 47)];
    bg1.backgroundColor = LLTheme.auxiliaryColor;
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:LLImage(@"icon_login_user")];
    userIcon.frame = CGRectMake(15, 3.5, 40, 40);
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(userIcon.right + 5, 3.5, self.view.width - 5 - userIcon.right - 15, 40)];
    usernameTextField.backgroundColor = [UIColor whiteColor];
    usernameTextField.layer.cornerRadius = 6;
    usernameTextField.layer.masksToBounds = YES;
    usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    usernameTextField.placeholder = @"请设置最多5个字的用户名";
    usernameTextField.font = [UIFont systemFontOfSize:16];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 1)];
    usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    usernameTextField.leftView = leftView;
    
    [bg1 addSubview:userIcon];
    [bg1 addSubview:usernameTextField];
    
    _usernameTextField = usernameTextField;
    
    _editButton = [UIButton buttonWithFrame:CGRectMake(15, bg1.bottom + 25, self.view.width - 30, 37) target:self title:@"修改" font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor] selector:@selector(editButtonActionClick:)];
    [_editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _editButton.backgroundColor = LLTheme.mainColor;
    _editButton.layer.cornerRadius = 6;
    _editButton.layer.masksToBounds = YES;
    _editButton.enabled = NO;
    [self.view addSubview:bg1];
    [self.view addSubview:_editButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.usernameTextField];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notify {
    _editButton.enabled = self.usernameTextField.text.length > 0;
}


- (void)editButtonActionClick:(UIButton *)sender {
    WEAKSELF();
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LLUser sharedInstance] modifyUserName:_usernameTextField.text completion:^(BOOL success, NSString * _Nullable errorMsg) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessage:errorMsg inView:weakSelf.view autoHideTime:1 interactionEnabled:YES completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:NO];
}
@end
