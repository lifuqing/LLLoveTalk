//
//  LLCommunityDetailViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommunityDetailViewController.h"
#import "LLCommunityListResponseModel.h"
#import "LLCommunityListTableViewCell.h"
#import "LLCommentTableViewCell.h"
#import "LLCommentListResponseModel.h"

@interface LLCommunityDetailViewController () <LLContainerListDelegate>
@property (nonatomic, strong) LLCommunityItemModel *communityItemModel;
@end

@implementation LLCommunityDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
    }
    return self;
}

- (instancetype)initWithCommunityItemModel:(LLCommunityItemModel *)model {
    _communityItemModel = model;
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
}

- (void)dealloc {
}



#pragma mark - public

#pragma mark - private

#pragma mark - action

#pragma mark - lazyloading

#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"LoveListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLAiLoveURLConfig class];
}

//- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
//    return @{@"phone":[LLUser sharedInstance].phone ?:@""};
//}
/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLCommentItemModel *model = self.listArray[indexPath.row];
    return [LLCommentTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [LLCommentTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLCommentTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.model = self.listArray[indexPath.row];
}

- (void)listController:(LLContainerListViewController *)listController didSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
//    LLCommentItemModel *model = self.listArray[indexPath.row];
    
}

@end
