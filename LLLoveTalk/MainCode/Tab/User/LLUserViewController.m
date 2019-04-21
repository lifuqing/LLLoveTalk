//
//  LLUserViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLUserViewController.h"
#import "LLLoginViewController.h"
#import "LLUserTableViewCell.h"
#import "LLEditInfoViewController.h"
#import "LLPrivateViewController.h"
#import "LLBuyVipViewController.h"

@interface LLUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;

@end

@implementation LLUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleToNavBar:self.title];
    [self.listTableView reloadData];
    [self.view addSubview:self.listTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangedNotification:) name:kUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStateChangedNotification:) name:kUserLoginStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVIPChangedNotification:) name:kUserVIPChangedNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userInfoChangedNotification:(NSNotification *)notify {
    [self.listTableView reloadData];
}

- (void)userLoginStateChangedNotification:(NSNotification *)notify {
    [self.listTableView reloadData];
}

- (void)userVIPChangedNotification:(NSNotification *)notify {
    [self.listTableView reloadData];
}

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _listTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
        if (@available(iOS 11, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _listTableView.estimatedRowHeight = 0;
            _listTableView.estimatedSectionHeaderHeight = 0;
            _listTableView.estimatedSectionFooterHeight = 0;
        }
        [_listTableView registerClass:[LLUserTableViewCell class] forCellReuseIdentifier:@"LLUserTableViewCellIdentifier"];
    }
    return _listTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LLUser sharedInstance].isLogin ? 4 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LLUserTableViewCell cellHeightWithModel:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLUserTableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.descLabel.text = @"";
    if (indexPath.row == 0) {
        cell.thumbView.image = LLImage(@"my_user");
        NSString *str = @"";
        if ([LLUser sharedInstance].phone.length > 7) {
            str = [[LLUser sharedInstance].username stringByAppendingFormat:@"-%@", [[LLUser sharedInstance].phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
        }
        cell.titleLabel.text = [LLUser sharedInstance].isLogin ? str : @"请点击登录";
    }
    else if ([LLUser sharedInstance].isLogin && indexPath.row == 1) {
        cell.thumbView.image = LLImage(@"my_vip");
        if ([LLUser sharedInstance].isSuperVIP) {
            cell.titleLabel.text = @"您已是永久会员";
            cell.descLabel.text = @"无限期";
        }
        else {
            cell.titleLabel.text = @"升级高级用户";
            cell.descLabel.text = [LLUser sharedInstance].ispaid ? [NSString stringWithFormat:@"会员剩余%ld天", (long)[LLUser sharedInstance].remaindays] : @"";
        }
    }
    else if (indexPath.row == ([LLUser sharedInstance].isLogin ? 2 : 1)) {
        cell.thumbView.image = LLImage(@"my_edit_info");
        cell.titleLabel.text = @"修改个人资料";
    }
    else if (indexPath.row == ([LLUser sharedInstance].isLogin ? 3 : 2)) {
        cell.thumbView.image = LLImage(@"my_private");
        cell.titleLabel.text = @"隐私政策";
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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
    else if ([LLUser sharedInstance].isLogin && indexPath.row == 1) {
        if ([LLUser sharedInstance].isSuperVIP) {
            [UIAlertController ll_showAlertWithTarget:self title:@"提示" message:@"您已是永久会员，可以使用全部功能" cancelTitle:@"好的" otherTitles:nil completion:nil];
        }
        else {
            LLBuyVipViewController *vc = [[LLBuyVipViewController alloc] init];
            [LLNav pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.row == ([LLUser sharedInstance].isLogin ? 2 : 1)) {
        if ([LLUser sharedInstance].isLogin) {
            LLEditInfoViewController *vc = [[LLEditInfoViewController alloc] init];
            [LLNav pushViewController:vc animated:YES];
        }
        else {
            LLLoginViewController *login = [[LLLoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }
    }
    else if (indexPath.row == ([LLUser sharedInstance].isLogin ? 3 : 2)) {
        LLPrivateViewController *vc = [[LLPrivateViewController alloc] init];
        [LLNav pushViewController:vc animated:YES];
    }
}

@end
