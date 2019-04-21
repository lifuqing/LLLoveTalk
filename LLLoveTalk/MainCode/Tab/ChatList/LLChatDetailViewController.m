//
//  LLChatDetailViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/16.
//

#import "LLChatDetailViewController.h"
#import "LLChatDetailTableViewCell.h"

@interface LLChatDetailViewController () <LLContainerListDelegate>
@property (nonatomic, copy) NSString *contentId;
@end

@implementation LLChatDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
    }
    return self;
}

- (instancetype)initWithContentId:(NSString *)contentId {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _contentId = [contentId copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBarItemWithTitle:self.chatListType == EChatListTypeJieXi ? @"恋爱解析" : @"聊天教学"];
    self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomAreaHeight, 0);
    [self requestData];
}

///列表请求在URLConfihg里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return self.chatListType == EChatListTypeJieXi ? @"LoveDetailParser" : @"ChatDetailParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLLoveTalkURLConfig class];
}

- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
    return @{@"phone":[LLUser sharedInstance].phone ?:@"", @"contentid":_contentId?:@""};
}

/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLChatDetailItemModel *model = self.listArray[indexPath.row];
    return [LLChatDetailTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [LLChatDetailTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLChatDetailTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    WEAKSELF();
    cell.imageDownloadFinishBlock = ^{
        [weakSelf.listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.model = self.listArray[indexPath.row];
}
@end
