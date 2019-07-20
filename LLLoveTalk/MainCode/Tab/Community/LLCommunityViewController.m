//
//  LLCommunityViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommunityViewController.h"
#import "LLCommunityListResponseModel.h"
#import "LLCommunityListTableViewCell.h"
#import "LLCommunityDetailViewController.h"
#import "LLCommunityNewStatusViewController.h"
#import "LLLoginViewController.h"

@interface LLCommunityViewController () <LLContainerListDelegate>

@end

@implementation LLCommunityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
        self.enablePreLoad = YES;
        self.enableTableBottomView = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleToNavBar:@"情感广场"];
    [self createRightItemWithImage:LLImage(@"btn_nav_edit") action:@selector(editNewItem:)];
    // Do any additional setup after loading the view.
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communityNewStatusCreateSuccessNotification:) name:@"kCommunityNewStatusCreateSuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCountChangedNotification:) name:@"kCommentCountChangedNotification" object:nil];
    
    WEAKSELF();
    [[NSNotificationCenter defaultCenter] addObserverForName:kUserLoginStateChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf requestData];
    }];
}

- (void)dealloc {
}



#pragma mark - public

#pragma mark - private
- (void)requestListDataSuccessWithArray:(NSArray *)array {
    [super requestListDataSuccessWithArray:array];
    
}

- (void)communityNewStatusCreateSuccessNotification:(NSNotification *)notify {
    [self requestData];
}

- (void)commentCountChangedNotification:(NSNotification *)notify {
    [self requestData];
}

#pragma mark - action

- (void)editNewItem:(id)sender {
    if ([LLUser sharedInstance].isLogin) {
        LLCommunityNewStatusViewController *vc = [[LLCommunityNewStatusViewController alloc] init];
        [LLNav pushViewController:vc animated:YES];
    }
    else {
        LLLoginViewController *vc = [[LLLoginViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - lazyloading

#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"LoveCommunityListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLAiLoveURLConfig class];
}

/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LLCommunityItemModel *model = self.listArray[indexPath.row];
    return [LLCommunityListTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [LLCommunityListTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLCommunityListTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.model = self.listArray[indexPath.row];
}

- (void)listController:(LLContainerListViewController *)listController didSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    LLCommunityItemModel *model = self.listArray[indexPath.row];
    
    LLCommunityDetailViewController *vc = [[LLCommunityDetailViewController alloc] initWithContentid:model.contentid];
    [LLNav pushViewController:vc animated:YES];
    
}

@end
