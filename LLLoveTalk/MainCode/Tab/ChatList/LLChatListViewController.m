//
//  LLChatListViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLChatListViewController.h"
#import "LLChatListTableViewCell.h"
#import "LLChatPrivateTableViewCell.h"
#import "LLBuyVipViewController.h"
#import "LLLoginViewController.h"

@interface LLChatListViewController () <LLContainerListDelegate>

@end

@implementation LLChatListViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
        _chatListType = EChatListTypeJiaoXue;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStateChangedNotification:) name:kUserLoginStateChangedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userVIPChangedNotification:) name:kUserVIPChangedNotification object:nil];
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//- (void)userLoginStateChangedNotification:(NSNotification *)notify {
//    [self requestData];
//}
//
//- (void)userVIPChangedNotification:(NSNotification *)notify {
//    [self requestData];
//}

#pragma mark - public

#pragma mark - private

#pragma mark - action

#pragma mark - lazyloading

#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return self.chatListType == EChatListTypeJieXi ? @"LoveListParser" : @"ChatListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLLoveTalkURLConfig class];
}

- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
    return @{@"phone":[LLUser sharedInstance].phone ?:@""};
}
/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLChatItemModel *model = self.listArray[indexPath.row];
    if (model.hide) {
        return [LLChatListTableViewCell cellHeightWithModel:model];
    }
    return [LLChatPrivateTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLChatItemModel *model = self.listArray[indexPath.row];
    if (model.hide) {
        return [LLChatPrivateTableViewCell class];
    }
    return [LLChatListTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLChatListTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.model = self.listArray[indexPath.row];
}

- (void)listController:(LLContainerListViewController *)listController didSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    LLChatItemModel *model = self.listArray[indexPath.row];
    if ([LLConfig sharedInstance].isCheck) {
        LLChatDetailViewController *vc = [[LLChatDetailViewController alloc] initWithContentId:model.contentid];
        vc.chatListType = self.chatListType;
        [LLNav pushViewController:vc animated:YES];
    }
    else {
        if ([LLUser sharedInstance].isLogin) {
            if (![LLUser sharedInstance].ispaid) {
                LLBuyVipViewController *vc = [[LLBuyVipViewController alloc] init];
                [LLNav pushViewController:vc animated:YES];
            }
            else {
                LLChatDetailViewController *vc = [[LLChatDetailViewController alloc] initWithContentId:model.contentid];
                vc.chatListType = self.chatListType;
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
