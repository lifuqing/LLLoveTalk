//
//  LLBuyVipViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/15.
//

#import "LLBuyVipViewController.h"
#import "LLIAPShare.h"
#import "LLBuyItemTableViewCell.h"
#import "LLInfoShowTableViewCell.h"
#import "LLProductListResponseModel.h"
#import <StoreKit/StoreKit.h>
#import "LLUserResponseModel.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "LLWebViewController.h"

@interface LLBuyVipViewController () <UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *descView;
@property (nonatomic, strong) TTTAttributedLabel *noteView;

@property (nonatomic, copy) NSArray<LLBuyItemModel *> *list;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDictionary *attributes;
@property (nonatomic, assign) NSInteger height;


@end
@implementation LLBuyVipViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.text = @"成为会员即表示同意《恋爱宝典会员服务协议》和《连续订阅服务协议》，自动订阅可随时取消。";
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        
        self.attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:LLTheme.subTitleColor, NSParagraphStyleAttributeName:style};
        
        self.height = [self.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributes context:nil].size.height;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBarItemWithTitle:@"升级高级用户"];
    
    [self.view addSubview:self.listTableView];
    [self requestData];
}

#pragma mark - public

#pragma mark - private

- (void)requestData {
    //self.productIds = [NSMutableSet setWithObjects:@"com.lianai.loveTalk.1", @"com.lianai.loveTalk.3", @"com.lianai.loveTalk.4", nil];
    
    WEAKSELF();
    LLURL *llurl = [[LLURL alloc] initWithParser:@"GetProductInfoParser" urlConfigClass:[LLLoveTalkURLConfig class]];
    
    NSDictionary *localDic = [[LLURLCacheManager sharedInstance] getCacheData:llurl.dataCacheIdentifier];
    if (!localDic) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nonnull model, BOOL isLocalCache) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        LLProductListResponseModel *productListModel = (LLProductListResponseModel *)model;
        weakSelf.list = [productListModel.list copy];
        NSSet<NSString *> *productIds = [NSSet setWithArray:[productListModel.list valueForKey:@"productId"]];
        [weakSelf configIAPWithIdentifiers:productIds];
        [weakSelf.listTableView reloadData];
    } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error,  LLBaseResponseModel * _Nonnull model) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [LLErrorView showErrorViewInView:weakSelf.view withErrorType:LLErrorTypeFailed withClickBlock:^{
            [weakSelf requestData];
        }];
    }];
}

- (void)configIAPWithIdentifiers:(NSSet *)identifiers {
    
    if(![LLIAPShare sharedHelper].iap) {
        [LLIAPShare sharedHelper].iap = [[LLIAPHelper alloc] initWithProductIdentifiers:identifiers];
    }
    
    if ([LLConfig sharedInstance].isDebug) {
        [LLIAPShare sharedHelper].iap.production = NO;
    }
    else {
        //审核时提供给Apple用于验证使用
        if ([[LLUser sharedInstance].phone isEqualToString:@"12345678910"]) {
            [LLIAPShare sharedHelper].iap.production = NO;
        }
        else {
            [LLIAPShare sharedHelper].iap.production = YES;
        }
    }
    
}

- (void)buyItem:(LLBuyItemModel *)item {
    if (![SKPaymentQueue canMakePayments]) {
        [MBProgressHUD showMessage:@"您的手机没有打开应用内付费购买" inView:self.view autoHideTime:2];
    }
    else {
        WEAKSELF();
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];//ADD LOADING
        hud.label.text = @"正在准备购买";
        
        [[LLIAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
         {
             __block SKProduct *destProduct = nil;
             [[LLIAPShare sharedHelper].iap.products enumerateObjectsUsingBlock:^(SKProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([obj.productIdentifier isEqualToString:item.productId]) {
                     destProduct = obj;
                     *stop = YES;
                 }
             }];
             
             if(response && destProduct) {
                 hud.label.text = @"正在购买";
                 [weakSelf buyProduct:destProduct];
                 DLog(@"Price: %@",[[LLIAPShare sharedHelper].iap getLocalePrice:destProduct]);
                 DLog(@"Title: %@",destProduct.localizedTitle);
                 
             }
             else {
                 [weakSelf showErrorAlert];
             }
         }];
    }
    
}

- (void)buyProduct:(SKProduct *)product {
    WEAKSELF();
    [[LLIAPShare sharedHelper].iap buyProduct:product onCompletion:^(SKPaymentTransaction* trans){
        if(trans.error)
        {
            if (trans.error.code != SKErrorPaymentCancelled) {
                [weakSelf showErrorAlert];
            }
            else {//点击取消
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }
            DLog(@"Fail %@",[trans.error localizedDescription]);
        }
        else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            hud.label.text = @"正在获取购买结果";
            NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
            [[LLIAPShare sharedHelper].iap checkReceipt:receiptData AndSharedSecret:[LLConfig sharedInstance].shareSecret onCompletion:^(NSString *response, NSError *error) {
                
                //Convert JSON String to NSDictionary
                NSDictionary* rec = [LLIAPShare toJSON:response];
                
                if([rec[@"status"] integerValue]==0)
                {
                    [[LLIAPShare sharedHelper].iap provideContentWithTransaction:trans];
                    DLog(@"SUCCESS %@",response);
                    DLog(@"Pruchases %@",[LLIAPShare sharedHelper].iap.purchasedProducts);
                    
                    NSString *receiptBase64 = [NSString base64StringFromData:receiptData];
                    [weakSelf buySuccessWithProductId:product.productIdentifier receiptBase64:receiptBase64];
                }
                else {
                    [weakSelf showErrorAlert];
                }
            }];
        }
        else if(trans.transactionState == SKPaymentTransactionStateFailed) {
            [weakSelf showErrorAlert];
        }
        else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
        
    }];
}

- (void)showErrorAlert {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIAlertController ll_showAlertWithTarget:self title:@"提示" message:@"会员购买失败，请稍后重试" cancelTitle:@"好的" otherTitles:nil completion:nil];
}

- (void)buySuccessWithProductId:(NSString *)productId receiptBase64:(NSString *)receiptBase64 {
    WEAKSELF();
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.label.text = @"正在更新会员状态";
    
    [[LLUser sharedInstance] uploadBuyProductId:productId receiptBase64:receiptBase64 completion:^(BOOL success, NSString * _Nullable errorMsg) {
        if (success) {
            [MBProgressHUD showMessage:@"会员状态更新成功" inView:weakSelf.view autoHideTime:2];
        }
        else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [UIAlertController ll_showAlertWithTarget:weakSelf title:@"非常抱歉" message:@"会员状态更新失败，下次启动会自动重试，状态更新成功之前请不要删除我们的APP。" cancelTitle:@"好的" otherTitles:nil completion:nil];
        }
        
        if (success && [LLUser sharedInstance].isSuperVIP) {
            [UIAlertController ll_showAlertWithTarget:weakSelf title:@"恭喜您" message:@"您已成功开通永久会员" cancelTitle:@"好的" otherTitles:nil completion:^(NSInteger buttonIndex) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)configInfoCell:(LLInfoShowTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell configCellWithImage:LLImage(@"icon_buyvip_huatong") title:@"10w+话术搜索，再也不用担心怎么回复妹子"];
    }
    if (indexPath.row == 1) {
        [cell configCellWithImage:LLImage(@"icon_buyvip_search") title:@"完整的搜索功能，海量话术，一搜即有"];
    }
    if (indexPath.row == 2) {
        [cell configCellWithImage:LLImage(@"icon_buyvip_location") title:@"拒绝尬聊，完美恋爱"];
    }
    if (indexPath.row == 3) {
        [cell configCellWithImage:LLImage(@"icon_buyvip_message") title:@"1000+聊天阅读案例"];
    }
}

#pragma mark - lazyloading

- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _listTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
        [_listTableView registerClass:[LLBuyItemTableViewCell class] forCellReuseIdentifier:@"BuyItemCellIdentifier"];
        [_listTableView registerClass:[LLInfoShowTableViewCell class] forCellReuseIdentifier:@"InfoShowCellIdentifier"];
        [_listTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"BuyItemHeaderIdentifier"];
        [_listTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"InfoShowHeaderIdentifier"];
        [_listTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"BuyItemFooterIdentifier"];
        
        if (@available(iOS 11, *)) {
            _listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _listTableView.estimatedRowHeight = 0;
            _listTableView.estimatedSectionHeaderHeight = 0;
            _listTableView.estimatedSectionFooterHeight = 0;
        }
    }
    return _listTableView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:LLImage(@"icon_buyvip_VIP")];
        _iconView.frame = CGRectMake((self.view.width - 103)/2.0, 138-15-73.5, 103, 73.5);
        
    }
    return _iconView;
}

- (UIView *)descView {
    if (!_descView) {
        _descView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        
        UIView *dot1 = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 152)/2.0, 11, 8, 8)];
        dot1.backgroundColor = LLTheme.mainColor;
        dot1.layer.cornerRadius = 4;
        dot1.layer.masksToBounds = YES;
        
        UIView *dot2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - (self.view.width - 152)/2.0 - 8, 11, 8, 8)];
        dot2.backgroundColor = LLTheme.mainColor;
        dot2.layer.cornerRadius = 4;
        dot2.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [UILabel ll_labelWithFrame:CGRectMake(0, 5, self.view.width, 20) text:@"会员特权" font:[UIFont boldSystemFontOfSize:16] textColor:LLTheme.mainColor textAlign:NSTextAlignmentCenter];
        
        [_descView addSubview:dot1];
        [_descView addSubview:titleLabel];
        [_descView addSubview:dot2];
        
    }
    return _descView;
}

- (TTTAttributedLabel *)noteView {
    if (!_noteView) {
        NSString *text = self.text;
        
        _noteView = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 20, self.height)];
        _noteView.numberOfLines = 0;
        _noteView.backgroundColor = [UIColor clearColor];
        _noteView.delegate = self;
        
        NSRange range1 = [text rangeOfString:@"《恋爱宝典会员服务协议》"];
        NSRange range2 = [text rangeOfString:@"《连续订阅服务协议》"];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 5;
        
        _noteView.attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:self.attributes];
        _noteView.linkAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:LLTheme.mainColor};
        _noteView.activeLinkAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:LLTheme.mainColor};
        _noteView.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        
        [_noteView addLinkToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"vipServiceProtocol.docx" ofType:nil]] withRange:range1];
        [_noteView addLinkToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"autoSubscribe.docx" ofType:nil]] withRange:range2];
    }
    return _noteView;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    LLWebViewController *vc = [[LLWebViewController alloc] init];
    
    vc.title = [url.absoluteString containsString:@"vipServiceProtocol.docx"] ? @"恋爱宝典会员服务协议" : @"连续订阅服务协议";
    vc.url = url;
    [LLNav pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.list.count > 0) {
        if (section == 0) {
            return self.list.count;
        }
        return 4;
    }
    else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count > 0 ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? [LLBuyItemTableViewCell cellHeightWithModel:nil] : 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 138;
    }
    else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.height + 10;
    }
    else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *aview = nil;
    if (section == 0) {
        aview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BuyItemHeaderIdentifier"];
        aview.contentView.backgroundColor = [UIColor whiteColor];
        [aview.contentView addSubview:self.iconView];
    }
    else {
        aview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"InfoShowHeaderIdentifier"];
        aview.contentView.backgroundColor = [UIColor whiteColor];
        [aview.contentView addSubview:self.descView];
    }
    return aview;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *aview = nil;
    if (section == 0) {
        aview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BuyItemFooterIdentifier"];
        aview.contentView.backgroundColor = [UIColor whiteColor];
        [aview.contentView addSubview:self.noteView];
    }
    return aview;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        LLBuyItemTableViewCell *buyCell = [tableView dequeueReusableCellWithIdentifier:@"BuyItemCellIdentifier" forIndexPath:indexPath];
        buyCell.model = self.list[indexPath.row];
        WEAKSELF();
        buyCell.clickBuyBlock = ^(LLBuyItemModel * _Nonnull item) {
            [weakSelf buyItem:item];
        };
        cell = buyCell;
    }
    else {
        LLInfoShowTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"InfoShowCellIdentifier" forIndexPath:indexPath];
        [self configInfoCell:infoCell atIndexPath:indexPath];
        cell = infoCell;
    }
    cell.clipsToBounds = YES;
    cell.exclusiveTouch = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


@end
