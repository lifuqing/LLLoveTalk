//
//  LLTagExampleListViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLTagExampleListViewController.h"
#import "LLTagExampleListResponseModel.h"
#import "LLExampleTableViewCell.h"
#import "LLChatPrivateTableViewCell.h"
#import "LLSearchViewController.h"
#import "LLLoginViewController.h"
#import "LLBuyVipViewController.h"

@interface LLTagExampleListViewController () <LLContainerListDelegate>
@property (nonatomic, strong) UIView *searchBar;

@property (nonatomic, strong) LLTagResponseModel *tagModel;
@end

@implementation LLTagExampleListViewController

- (instancetype)initWithItem:(LLTagResponseModel *)item {
    _tagModel = item;
    return [self initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarItemWithTitle:_tagModel.catename];
    [self requestData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStateChangedNotification:) name:kUserLoginStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVIPChangedNotification:) name:kUserVIPChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)userLoginStateChangedNotification:(NSNotification *)notify {
    [self requestData];
}

- (void)userVIPChangedNotification:(NSNotification *)notify {
    [self requestData];
}


#pragma mark - public

#pragma mark - private
- (void)requestListDataSuccessWithArray:(NSArray *)array {
    [super requestListDataSuccessWithArray:array];
    self.listTableView.tableHeaderView = self.searchBar;
}

#pragma mark - action
- (void)searchButtonActionClick:(UIButton *)sender {
    if ([LLUser sharedInstance].isLogin) {
        if ([LLUser sharedInstance].ispaid) {
            LLSearchViewController *vc = [[LLSearchViewController alloc] init];
            [LLNav pushViewController:vc animated:YES];
        }
        else {
            LLBuyVipViewController *vc = [[LLBuyVipViewController alloc] init];
            [LLNav pushViewController:vc animated:YES];
        }
    }
    else {
        LLLoginViewController *vc = [[LLLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - lazyloading

- (UIView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 55)];
        UIButton *searchButton = [UIButton buttonWithFrame:CGRectMake(15, 8, _searchBar.width - 30, 38) target:self title:@"搜索聊天话术" font:[UIFont systemFontOfSize:18] textColor:RGBS(210) selector:@selector(searchButtonActionClick:)];
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        searchButton.layer.cornerRadius = 8;
        searchButton.backgroundColor = [UIColor whiteColor];
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, searchButton.imageView.width + 20, 0, 0);
        [searchButton setImage:LLImage(@"icon_gray_search") forState:UIControlStateNormal];
        searchButton.adjustsImageWhenHighlighted = NO;
        [_searchBar addSubview:searchButton];
        _searchBar.backgroundColor = LLTheme.searchBGColor;
    }
    return _searchBar;
}

#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"LoveDetailListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLLoveTalkURLConfig class];
}

///列表请求额外配置的参数，内部refresh第一页数据请求的时候会清空参数，需要重新传参。
- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
    return @{@"cateid":_tagModel.cateid?:@"", @"phone":[LLUser sharedInstance].phone?:@""};
}
/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLTagExampleModel *model = self.listArray[indexPath.row];
    if (model.hide) {
        return [LLChatPrivateTableViewCell cellHeightWithModel:model];
    }
    return [LLExampleTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLTagExampleModel *model = self.listArray[indexPath.row];
    if (model.hide) {
        return [LLChatPrivateTableViewCell class];
    }
    return [LLExampleTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLExampleTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.model = self.listArray[indexPath.row];
}

- (void)listController:(LLContainerListViewController *)listController didSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    LLTagExampleModel *model = self.listArray[indexPath.row];
    if (model.hide) {
        if ([LLUser sharedInstance].isLogin) {
            if (![LLUser sharedInstance].ispaid) {
                LLBuyVipViewController *vc = [[LLBuyVipViewController alloc] init];
                [LLNav pushViewController:vc animated:YES];
            }
        }
        else {
            LLLoginViewController *vc = [[LLLoginViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}
@end
