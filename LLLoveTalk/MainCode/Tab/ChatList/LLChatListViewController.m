//
//  LLChatListViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "LLChatListViewController.h"
#import "LLChatListTableViewCell.h"

@interface LLChatListViewController () <LLContainerListDelegate>

@end

@implementation LLChatListViewController
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
    self.view.backgroundColor = [UIColor blueColor];
}

#pragma mark - public

#pragma mark - private

#pragma mark - action

#pragma mark - lazyloading

#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"ChatListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLLoveTalkURLConfig class];
}

/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [LLChatListTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull UITableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor redColor];
}
@end
