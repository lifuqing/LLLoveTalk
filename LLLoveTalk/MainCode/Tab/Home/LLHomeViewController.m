//
//  LLHomeViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLHomeViewController.h"
#import "LLSearchBar.h"
#import "LLTagCollectionViewCell.h"
#import "LLHeaderCollectionReusableView.h"
#import "LLTagExampleListViewController.h"

static NSString * const kHeaderIdentifier = @"kHeaderIdentifier";
static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface LLHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) LLSearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LLHomeViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTitleToNavBar:self.title];
    [self.view addSubview:self.collectionView];
}


#pragma mark - public

#pragma mark - private

#pragma mark - action

#pragma mark - lazyloading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 10.0f;
        collectionViewLayout.minimumInteritemSpacing = 10.0f;
        collectionViewLayout.itemSize = CGSizeMake(100, 20);
        collectionViewLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, SCREEN_WIDTH, self.view.height - self.searchBar.bottom) collectionViewLayout:collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LLHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier];
        [_collectionView registerClass:[LLTagCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
    }
    return _collectionView;
}

#pragma mark - datasource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 38;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.model = @"I'am a title";
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LLHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
    header.titleLabel.text = @"我在测试";
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LLTagExampleListViewController *vc = [[LLTagExampleListViewController alloc] init];
    [LLNav pushViewController:vc animated:YES];
}


@end
