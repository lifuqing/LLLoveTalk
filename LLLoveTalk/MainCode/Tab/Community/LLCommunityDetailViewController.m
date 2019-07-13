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
#import "LLImageTools.h"
#import "UIImage+LLTools.h"

@interface LLCommunityDetailViewController () <LLContainerListDelegate, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, copy) NSString *contentid;

@property (nonatomic, strong) UIView *commentBar;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation LLCommunityDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDelegate = self;
        self.enablePreLoad = YES;
        self.enableTableBottomView = YES;
    }
    return self;
}

- (instancetype)initWithContentid:(NSString *)contentid {
    _contentid = contentid;
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    self.listTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, SafeBottomAreaHeight + 45, 0);
    [super viewDidLoad];
    
    [self addBackBarItemWithTitle:@""];
    
    [self requestData];
    
    
    [self.view addSubview:self.commentBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
}



#pragma mark - public

#pragma mark - private
- (void)requestListDataSuccessWithArray:(NSArray *)array {
    [super requestListDataSuccessWithArray:array];
    [self addTitleToNavBar:self.author.username];
}
#pragma mark - action
- (void)sendButtonActionClick:(UIButton *)sender {
    [self.commentTextField resignFirstResponder];
    sender.enabled = NO;
    LLURL *llurl = [[LLURL alloc] initWithParser:@"SendCommentParser" urlConfigClass:[LLAiLoveURLConfig class]];
    [llurl.params addEntriesFromDictionary:@{@"comments":self.commentTextField.text?:@"", @"contentid":self.contentid?:@""}];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        sender.enabled = YES;
        [MBProgressHUD showMessage:@"发布成功" inView:weakSelf.view autoHideTime:1];
        weakSelf.commentTextField.text = @"";
        [weakSelf requestData];
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        sender.enabled = YES;
        [MBProgressHUD showMessage:model.errorMsg ?: @"发布失败" inView:weakSelf.view autoHideTime:1];
    }];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify {
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardH = MIN(keyboardEndFrame.size.width, keyboardEndFrame.size.height);
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.commentBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    } completion:nil];
    
}
- (void)keyboardWillShowNotification:(NSNotification *)notify {
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    
    CGRect keyboardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardH = MIN(keyboardEndFrame.size.width, keyboardEndFrame.size.height);
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.commentBar.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    } completion:nil];
    
}
- (void)keyboardWillHideNotification:(NSNotification *)notify {
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notify.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue] << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.commentBar.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notify {
    self.sendButton.enabled = self.commentTextField.text.length > 0;
}

#pragma mark - lazyloading


- (LLCommunityItemModel *)author {
    return ((LLCommentListResponseModel *)self.listDataSource.listResponselModel).author;
}

- (UIView *)commentBar {
    if (!_commentBar) {
        _commentBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - SafeBottomAreaHeight - 45 - 0, self.view.width, 45 + SafeBottomAreaHeight)];
        _commentBar.backgroundColor = RGBS(235);
        _commentBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(15, 5, self.view.width - 30, 35)];
        bg.backgroundColor = [UIColor whiteColor];
        bg.layer.cornerRadius = 6;
        
        
        [_commentBar addSubview:bg];
        [_commentBar addSubview:self.commentTextField];
        [_commentBar addSubview:self.sendButton];
    }
    return _commentBar;
}

- (UITextField *)commentTextField {
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, self.view.width - 75 - 15 - 5, 45)];
        _commentTextField.placeholder = @"请输入评论";
        _commentTextField.delegate = self;
    }
    return _commentTextField;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton ll_buttonWithFrame:CGRectMake(self.commentBar.width - 75, 10, 50, 25) target:self title:@"发表" font:[UIFont fontWithName:@"PingFang-SC-Medium" size: 13] textColor:[UIColor whiteColor] selector:@selector(sendButtonActionClick:)];
        [_sendButton setBackgroundImage:[UIImage ll_createImageWithColor:RGBS(208)] forState:UIControlStateDisabled];
        [_sendButton setBackgroundImage:[UIImage ll_createImageWithColor:LLTheme.mainColor] forState:UIControlStateNormal];
        _sendButton.layer.cornerRadius = 6;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.enabled = NO;
        _sendButton.adjustsImageWhenHighlighted = NO;
    }
    return _sendButton;
}
#pragma mark - delegate


///列表请求在URLConfig里面的Parser唯一标识
- (nonnull NSString *)requestListParserForListController:(nonnull LLContainerListViewController *)listController {
    return @"LoveCommentsListParser";
}

///parser所在的urlconfig类
- (nonnull Class)requestListURLConfigClassForListController:(nonnull LLContainerListViewController *)listController {
    return [LLAiLoveURLConfig class];
}

- (nullable NSDictionary *)requestListPargamsForListController:(nonnull LLContainerListViewController *)listController {
    return @{@"contentid":_contentid ?:@""};
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : 0;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//}

- (NSInteger)listController:(nonnull LLContainerListViewController *)listController sectionCountInTableView:(nonnull UITableView *)tableView {
    return (self.author ? 1 : 0) + (self.listArray.count > 0 ? 1 : 0);
}

- (NSInteger)listController:(nonnull LLContainerListViewController *)listController rowCountInSection:(NSInteger)section {
    return section == 0 ? (self.author ? 1 : 0) : self.listDataSource.list.count;
}

/**
 * List Content
 * @brief 列表内容
 */

///内容行高，如果用约束实现cell高度动态计算，return UITableViewAutomaticDimension即可
- (CGFloat)listController:(nonnull LLContainerListViewController *)listController rowHeightAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LLCommunityListTableViewCell cellHeightWithModel:self.author];
    }
    LLCommentItemModel *model = self.listArray[indexPath.row];
    return [LLCommentTableViewCell cellHeightWithModel:model];
}

///内容视图Class。默认为UITableViewCell。
- (nullable Class)listController:(nonnull LLContainerListViewController *)listController cellClassAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LLCommunityListTableViewCell class];
    }
    return [LLCommentTableViewCell class];
}

///复用内容视图
- (void)listController:(nonnull LLContainerListViewController *)listController reuseCell:(nonnull LLBaseTableViewCell *)cell atIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cell.model = self.author;
        ((LLCommunityListTableViewCell *)cell).photoViewActionBlock = ^(UIImageView * _Nonnull photoView, LLCommunityItemModel * _Nonnull itemModel) {
            [LLImageTools ImageZoomWithImageView:photoView canSaveToAlbum:YES];
        };
    }
    else {
        cell.model = self.listArray[indexPath.row];
    }
    
}

- (void)listController:(LLContainerListViewController *)listController didSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
//    LLCommentItemModel *model = self.listArray[indexPath.row];
    
}

@end
