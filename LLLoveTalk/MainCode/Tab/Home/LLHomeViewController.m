//
//  LLHomeViewController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLHomeViewController.h"
#import "LLSearchBar.h"
#import "LLTagCollectionViewCell.h"
#import "LLHeaderCollectionReusableView.h"
#import "LLTagExampleListViewController.h"
#import "LLLoginViewController.h"
#import "LLListBaseDataSource.h"
#import "LLHomeListResponseModel.h"
#import "LLSearchViewController.h"
#import "LLLoginViewController.h"
#import "LLSearchKeywordsModel.h"

#define kDefaultSearchString @"搜索聊天话术"

static NSString * const kHeaderIdentifier = @"kHeaderIdentifier";
static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface LLHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, LLListBaseDataSourceDelegate>

@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LLListBaseDataSource *listDataSource;
@property (nonatomic, strong) NSMutableArray <LLHomeItemResponseModel *> *list;
@property (nonatomic) NSTimer *requestKeywordsTimer;
@property (nonatomic) NSTimer *refreshKeywordsTimer;
@property (nonatomic, strong) LLSearchKeywordsModel *searchKeywordsModel;
@property (nonatomic, strong) NSMutableArray *hasShowArray;
@end

@implementation LLHomeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _listDataSource = [[LLListBaseDataSource alloc] initWithDelegate:self parser:@"HomeListParser" urlConfigClass:[LLAiLoveURLConfig class]];
        _list = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//view的底部是tabbar的顶部，不会被覆盖一部分
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTitleToNavBar:self.title];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.collectionView];
    [self requestData];
    [self startRequestKeywords];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [_requestKeywordsTimer invalidate];
//    _requestKeywordsTimer = nil;
//    [_refreshKeywordsTimer invalidate];
//    _refreshKeywordsTimer = nil;
    
}

#pragma mark - public

#pragma mark - private

- (void)startRequestKeywords {
    if (!_requestKeywordsTimer) {
        _requestKeywordsTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startRequestKeywords) userInfo:nil repeats:YES];
    }
    LLURL *llurl = [[LLURL alloc] initWithParser:@"SearchKeywordsParser" urlConfigClass:[LLAiLoveURLConfig class]];
    WEAKSELF();
    [[LLHttpEngine sharedInstance] sendRequestWithLLURL:llurl target:self success:^(NSURLResponse * _Nullable response, NSDictionary * _Nullable result, LLBaseResponseModel * _Nullable model, BOOL isLocalCache) {
        if ([model isKindOfClass:[LLSearchKeywordsModel class]]) {
            weakSelf.searchKeywordsModel = (LLSearchKeywordsModel *)model;
            if (weakSelf.searchKeywordsModel.keywords.count > 0) {
                [weakSelf refreshKeywords];
            }
        }
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error, LLBaseResponseModel * _Nullable model) {
        
    }];
}

- (void)refreshKeywords {
    [_refreshKeywordsTimer invalidate];
    _refreshKeywordsTimer = nil;
    if (!_hasShowArray) {
        _hasShowArray = [NSMutableArray array];
    }
    else {
        [self.hasShowArray removeAllObjects];
    }
    
    _refreshKeywordsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(replaceKeyword) userInfo:nil repeats:YES];
}

- (void)replaceKeyword {
    [self.searchKeywordsModel.keywords enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![self.hasShowArray containsObject:obj]) {
            [self.hasShowArray addObject:obj];
            [self.searchButton setTitle:obj forState:UIControlStateNormal];
            *stop = YES;
        }
    }];
}

- (void)prepareRequest {
    if (self.list.count) {
        [self.list removeAllObjects];
        [self.collectionView reloadData];
    }
    [LLErrorView hideErrorViewInView:self.collectionView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)requestData {
    [self prepareRequest];
    [self.listDataSource load];
}

- (void)finishOfDataSource:(LLListBaseDataSource *)dataSource {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    WEAKSELF();
    if (dataSource.error) {
        if (dataSource.type == LLRequestTypeRefresh) {
            [LLErrorView showErrorViewInView:self.collectionView withErrorType:LLErrorTypeFailed withClickBlock:^{
                [weakSelf requestData];
            }];
        }
        
    }
    else {
        if (dataSource.list.count) {
            self.list.array = dataSource.list;
            [self.collectionView reloadData];
        }
        else {
            [LLErrorView showErrorViewInView:self.collectionView withErrorType:LLErrorTypeNoData withClickBlock:^{
                [weakSelf requestData];
            }];
        }
    }
}

- (void)configColorHeader:(nullable LLHeaderCollectionReusableView *)header cell:(nullable LLTagCollectionViewCell *)cell inSection:(NSInteger)section {
    NSInteger i = section % 6;
    UIColor *color = [UIColor lightGrayColor];
    if (i == 0) color = RGB(208, 223, 169);
    else if (i == 1) color = RGB(247, 227, 158);
    else if (i == 2) color = RGB(239, 191, 203);
    else if (i == 3) color = RGB(214, 235, 229);
    else if (i == 4) color = RGB(214, 220, 233);
    else if (i == 5) color = RGB(220, 236, 248);
    header.backgroundColor = color;
    cell.backgroundColor = color;
}

#pragma mark - action
- (void)searchButtonActionClick:(UIButton *)sender {
    if (![LLConfig sharedInstance].isPassedCheck) {
        LLSearchViewController *vc = [[LLSearchViewController alloc] init];
        NSString *str = [self.searchButton titleForState:UIControlStateNormal];
        if (![str isEqualToString:kDefaultSearchString]) {
            vc.defaultKeyword = str;
        }
        
        [LLNav pushViewController:vc animated:YES];
    }
    else {
        if ([LLUser sharedInstance].isLogin) {
            LLSearchViewController *vc = [[LLSearchViewController alloc] init];
            NSString *str = [self.searchButton titleForState:UIControlStateNormal];
            if (![str isEqualToString:kDefaultSearchString]) {
                vc.defaultKeyword = str;
            }
            
            [LLNav pushViewController:vc animated:YES];
        }
        else {
            LLLoginViewController *vc = [[LLLoginViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

#pragma mark - lazyloading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 12;
        collectionViewLayout.minimumInteritemSpacing = 20;
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(8, 22, 8, 22);
        collectionViewLayout.itemSize = CGSizeMake((SCREEN_WIDTH - collectionViewLayout.minimumInteritemSpacing * 2 - collectionViewLayout.sectionInset.left * 2)/3.0, 26);
        collectionViewLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 26);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, SCREEN_WIDTH, self.view.height - self.searchBar.bottom) collectionViewLayout:collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LLHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        [_collectionView registerClass:[LLTagCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(12, 0, 12, 0);
        
    }
    return _collectionView;
}

- (UIView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 55)];
        UIButton *searchButton = [UIButton ll_buttonWithFrame:CGRectMake(15, 8, _searchBar.width - 30, 38) target:self title:kDefaultSearchString font:[UIFont systemFontOfSize:18] textColor:[UIColor grayColor] selector:@selector(searchButtonActionClick:)];
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        searchButton.layer.cornerRadius = 8;
        searchButton.backgroundColor = [UIColor whiteColor];
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, searchButton.imageView.width + 20, 0, 0);
        [searchButton setImage:LLImage(@"icon_gray_search") forState:UIControlStateNormal];
        searchButton.adjustsImageWhenHighlighted = NO;
        [_searchBar addSubview:searchButton];
        self.searchButton = searchButton;
        _searchBar.backgroundColor = LLTheme.searchBGColor;
    }
    return _searchBar;
}

#pragma mark - datasource & delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.list.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list[section].child.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [self configColorHeader:nil cell:cell inSection:indexPath.section];
    cell.model = self.list[indexPath.section].child[indexPath.item];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LLHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
    [self configColorHeader:header cell:nil inSection:indexPath.section];
    LLHomeItemResponseModel *item = self.list[indexPath.section];
    header.titleLabel.text = item.fname;
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LLTagExampleListViewController *vc = [[LLTagExampleListViewController alloc] initWithItem:self.list[indexPath.section].child[indexPath.item]];
    [LLNav pushViewController:vc animated:YES];
    
}



@end
