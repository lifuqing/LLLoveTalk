//
//  LLUserViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLUserViewController.h"
#import "LLLoginViewController.h"
#import "LLUserTableViewCell.h"
#import "LLPrivateViewController.h"
#import "LLBuyVipViewController.h"

@interface LLUserViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headIconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *vipLabel;
@property (nonatomic, strong) UILabel *vipTimeLabel;

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *sig_selfTextField;
@property (nonatomic, strong) UITextField *sig_loveTextField;
@end

@implementation LLUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBS(245);
    [self addTitleToNavBar:self.title];
    
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 75)];
    topBgView.backgroundColor = LLTheme.mainColor;
    
    [self.view addSubview:topBgView];
    
    [self.view addSubview:self.listTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangedNotification:) name:kUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStateChangedNotification:) name:kUserLoginStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVIPChangedNotification:) name:kUserVIPChangedNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification

- (void)userInfoChangedNotification:(NSNotification *)notify {
    [self refreshUI];
}

- (void)userLoginStateChangedNotification:(NSNotification *)notify {
    [self refreshUI];
}

- (void)userVIPChangedNotification:(NSNotification *)notify {
    [self refreshUI];
}

#pragma mark - action
- (void)tapHeadAction:(UITapGestureRecognizer *)tap {
    if (![LLUser sharedInstance].isLogin) {
        LLLoginViewController *login = [[LLLoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else {
        [UIAlertController ll_showAlertWithTarget:self title:@"提示" message:@"您确定要退出登录？" cancelTitle:@"取消" otherTitles:@[@"确定"] completion:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[LLUser sharedInstance] logout];
            }
        }];
    }
}

- (void)modifyUserName:(NSString *)text {
    WEAKSELF();
    [[LLUser sharedInstance] modifyUserInfo:text type:EModifyInfoTypeUserName completion:^(BOOL success, NSString * _Nullable errorMsg) {
        if (success) {
            [weakSelf refreshUI];
        }
        else {
            [MBProgressHUD showMessage:errorMsg inView:weakSelf.view autoHideTime:1];
            [weakSelf.nameTextField becomeFirstResponder];
        }
    }];
}

- (void)modifySig_Self:(NSString *)text {
    WEAKSELF();
    [[LLUser sharedInstance] modifyUserInfo:text type:EModifyInfoTypeSigSelf completion:^(BOOL success, NSString * _Nullable errorMsg) {
        if (success) {
            [weakSelf refreshUI];
        }
        else {
            [MBProgressHUD showMessage:errorMsg inView:weakSelf.view autoHideTime:1];
            [weakSelf.sig_selfTextField becomeFirstResponder];
        }
    }];
}

- (void)modifySig_Love:(NSString *)text {
    WEAKSELF();
    [[LLUser sharedInstance] modifyUserInfo:text type:EModifyInfoTypeSigLove completion:^(BOOL success, NSString * _Nullable errorMsg) {
        if (success) {
            [weakSelf refreshUI];
        }
        else {
            [MBProgressHUD showMessage:errorMsg inView:weakSelf.view autoHideTime:1];
            [weakSelf.sig_loveTextField becomeFirstResponder];
        }
    }];
}

#pragma mark - private
- (void)refreshUI {
    [self.listTableView reloadData];
    [self refreshHeaderView];
}

- (void)refreshHeaderView {
    
    if ([LLUser sharedInstance].isLogin) {
        _headIconView.image = nil;
        [_headIconView sd_setImageWithURL:[NSURL URLWithString:[LLUser sharedInstance].head_file] placeholderImage:LLImage(@"my_user_head")];
        
        _titleLabel.text = [LLUser sharedInstance].username;
        
        if ([LLUser sharedInstance].userid.length > 10) {
            _subTitleLabel.text = [NSString stringWithFormat:@"ID:%@", [[LLUser sharedInstance].userid substringToIndex:9]];
        }
        else {
            _subTitleLabel.text = [NSString stringWithFormat:@"ID:%@", [LLUser sharedInstance].userid ?: @"未知"];
        }
        
    }
    else {
        _headIconView.image = LLImage(@"my_user_head");
        _titleLabel.text = @"登录";
        _subTitleLabel.text = @"请点击登录";
    }
    
    
    if ([LLUser sharedInstance].isLogin && [LLUser sharedInstance].ispaid) {
        _vipLabel.backgroundColor = RGB(255, 166, 10);
        if ([LLUser sharedInstance].isSuperVIP) {
            _vipTimeLabel.text = @"无限期";
        }
        else {
            _vipTimeLabel.text = [NSString stringWithFormat:@"会员剩余%ld天", MAX(0, (long)[LLUser sharedInstance].remaindays)];
        }
        
    }
    else {
        _vipLabel.backgroundColor = RGBS(192);
        _vipTimeLabel.text = @"未激活";
    }
}

#pragma mark - lazyloading
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        if (@available(iOS 11, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _listTableView.estimatedRowHeight = 0;
            _listTableView.estimatedSectionHeaderHeight = 0;
            _listTableView.estimatedSectionFooterHeight = 0;
        }
        [_listTableView registerClass:[LLUserTableViewCell class] forCellReuseIdentifier:@"LLUserTableViewCellIdentifier"];
        _listTableView.tableHeaderView = self.headerView;
    }
    return _listTableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        CGFloat vipDescHeight = [LLConfig sharedInstance].isPassedCheck ? 40 : 0;
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100 + vipDescHeight)];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.view.width - 30, _headerView.height)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        _headIconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        _headIconView.backgroundColor = RGBS(245);
        _headIconView.layer.cornerRadius = 6;
        _headIconView.layer.masksToBounds = YES;
        _headIconView.contentMode = UIViewContentModeScaleAspectFill;
        
        _titleLabel = [UILabel ll_labelWithFrame:CGRectMake(_headIconView.right + 15, _headIconView.top + 13, bgView.width - _headIconView.right - 15, 16) text:@"" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 16] textColor:LLTheme.titleSecondColor textAlign:NSTextAlignmentLeft];
        
        _subTitleLabel = [UILabel ll_labelWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 17, _titleLabel.width, 14) text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.grayTextColor textAlign:NSTextAlignmentLeft];
        
        _vipLabel = [UILabel ll_labelWithFrame:CGRectMake(_headIconView.left, _headIconView.bottom + 15, 70, 25) text:@"高级VIP" font:[UIFont fontWithName:@"PingFang-SC-Bold" size: 14] textColor:[UIColor whiteColor] textAlign:NSTextAlignmentCenter];
        _vipLabel.layer.cornerRadius = 6;
        _vipLabel.layer.masksToBounds = YES;
        
        _vipTimeLabel = [UILabel ll_labelWithFrame:CGRectMake(_subTitleLabel.left, _vipLabel.top + (25 - 14)/2.0, bgView.width - _subTitleLabel.left, 14) text:@"" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14] textColor:LLTheme.grayTextColor textAlign:NSTextAlignmentLeft];
        
        [_headerView addSubview:bgView];
        [bgView addSubview:_headIconView];
        [bgView addSubview:_titleLabel];
        [bgView addSubview:_subTitleLabel];
        if ([LLConfig sharedInstance].isPassedCheck) {
            [bgView addSubview:_vipLabel];
            [bgView addSubview:_vipTimeLabel];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadAction:)];
        [_headerView addGestureRecognizer:tap];
        
        [self refreshHeaderView];
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LLUser sharedInstance].isLogin ? ([LLConfig sharedInstance].isPassedCheck ? 3 : 2) : 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([LLUser sharedInstance].isLogin) {
        if (section == 0)
            return 3;
        else if (section == 1)
            return 1;
        else
            return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLUserTableViewCell cellHeightWithModel:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLUserTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([LLUser sharedInstance].isLogin) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [cell configUIWithImage:nil title:@"昵称:" desc:nil descTextField:[LLUser sharedInstance].username descPlaceholder:@"请输入昵称"];
                self.nameTextField = cell.descTextField;
            }
            else if (indexPath.row == 1) {
                [cell configUIWithImage:nil title:@"个性签名:" desc:nil descTextField:([LLUser sharedInstance].sig_self.length ? [LLUser sharedInstance].sig_self : nil) descPlaceholder:@"我很懒，什么都没留下"];
                self.sig_selfTextField = cell.descTextField;
            }
            else if (indexPath.row == 2) {
                [cell configUIWithImage:nil title:@"爱情宣言:" desc:nil descTextField:([LLUser sharedInstance].sig_love.length ? [LLUser sharedInstance].sig_love : nil) descPlaceholder:@"请输入您的爱情宣言"];
                self.sig_loveTextField = cell.descTextField;
            }
            cell.descTextField.returnKeyType = UIReturnKeyDone;
            cell.descTextField.tag = 100 + indexPath.row;
            cell.descTextField.delegate = self;
        }
        else if (indexPath.section == 1 && [LLConfig sharedInstance].isPassedCheck) {
            if ([LLUser sharedInstance].isSuperVIP) {
                [cell configUIWithImage:LLImage(@"my_vip") title:@"您已是永久会员" desc:nil descTextField:nil descPlaceholder:nil];
            }
            else {
                [cell configUIWithImage:LLImage(@"my_vip") title:@"升级高级用户" desc:nil  descTextField:nil descPlaceholder:nil];
            }
        }
        else {
            [cell configUIWithImage:LLImage(@"my_private") title:@"隐私政策" desc:nil descTextField:nil descPlaceholder:nil];
        }
    }
    else {
        [cell configUIWithImage:LLImage(@"my_private") title:@"隐私政策" desc:nil descTextField:nil descPlaceholder:nil];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([LLUser sharedInstance].isLogin) {
        if (![LLConfig sharedInstance].isPassedCheck && indexPath.section == 1) {
            LLPrivateViewController *vc = [[LLPrivateViewController alloc] init];
            [LLNav pushViewController:vc animated:YES];
        }
        else {
            if (indexPath.section == 1) {
                if ([LLUser sharedInstance].isSuperVIP) {
                    [UIAlertController ll_showAlertWithTarget:self title:@"提示" message:@"您已是永久会员，可以使用全部功能" cancelTitle:@"好的" otherTitles:nil completion:nil];
                }
                else {
                    LLBuyVipViewController *vc = [[LLBuyVipViewController alloc] init];
                    [LLNav pushViewController:vc animated:YES];
                }
            }
            else if (indexPath.section == 2) {
                LLPrivateViewController *vc = [[LLPrivateViewController alloc] init];
                [LLNav pushViewController:vc animated:YES];
            }
        }
        
    }
    else {
        LLPrivateViewController *vc = [[LLPrivateViewController alloc] init];
        [LLNav pushViewController:vc animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.nameTextField)
        self.sig_selfTextField.enabled = self.sig_loveTextField.enabled = NO;
    else if (textField == self.sig_selfTextField)
        self.nameTextField.enabled = self.sig_loveTextField.enabled = NO;
    else if (textField == self.sig_loveTextField)
        self.nameTextField.enabled = self.sig_selfTextField.enabled = NO;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.nameTextField.enabled = self.sig_selfTextField.enabled = self.sig_loveTextField.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *nameTrim = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textField == self.nameTextField && nameTrim.length == 0) {
        [MBProgressHUD showMessage:@"用户昵称不能为空" inView:self.view autoHideTime:1];
        return NO;
    }
    
    [textField resignFirstResponder];
    
    if (textField == self.nameTextField) {
        [self modifyUserName:textField.text];
    }
    
    if (textField == self.sig_selfTextField) {
        [self modifySig_Self:textField.text];
    }
    
    if (textField == self.sig_loveTextField) {
        [self modifySig_Love:textField.text];
    }
    return YES;
}

@end
