//
//  LLSearchViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLSearchViewController.h"
#import "LLTagExampleListResponseModel.h"
#import "LLExampleTableViewCell.h"
#import "LLChatPrivateTableViewCell.h"
#import "LLSearchViewController.h"
#import "LLLoginViewController.h"
#import "LLBuyVipViewController.h"

@interface LLSearchViewController ()<UISearchBarDelegate, LLContainerListDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation LLSearchViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarItemWithTitle:@""];
    self.navigationItem.titleView = self.searchBar;
    if(@available(iOS 11.0, *)) {
        [[self.searchBar.heightAnchor constraintEqualToConstant:44] setActive:YES];
    }
    
    self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomAreaHeight, 0);
    self.listTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, SafeNavgBarAreaTop, self.view.width - 60, NormalNavBarHeight)];
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.showsCancelButton = YES;
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.placeholder = @"请输入关键字";
        _searchBar.delegate = self;
        [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    }
    return _searchBar;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [self.searchBar endEditing:NO];
        [self requestData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:NO];
}



///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"SearchListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLLoveTalkURLConfig class];
}

///列表请求额外配置的参数，内部refresh第一页数据请求的时候会清空参数，需要重新传参。
- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
    return @{@"keywords":_searchBar.text?:@"", @"phone":[LLUser sharedInstance].phone?:@""};
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
    [self.searchBar endEditing:NO];
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.searchBar endEditing:NO];
}
@end
