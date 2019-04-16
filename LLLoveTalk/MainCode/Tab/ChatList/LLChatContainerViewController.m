//
//  LLChatContainerViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLChatContainerViewController.h"
#import "LLTransitionContainerViewController.h"
#import "LLChatListViewController.h"
#import <SPPageMenu/SPPageMenu.h>

@interface LLChatContainerViewController () <SPPageMenuDelegate>
@property (nonatomic, strong) LLTransitionContainerViewController *container;
@property (nonatomic, strong) SPPageMenu *segment;

@end

@implementation LLChatContainerViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LLChatListViewController *v1 = [[LLChatListViewController alloc] init];
        v1.chatListType = EChatListTypeJiaoXue;
        LLChatListViewController *v2 = [[LLChatListViewController alloc] init];
        v2.chatListType = EChatListTypeJieXi;
        
        _container = [[LLTransitionContainerViewController alloc] initWithViewControllers:@[v1, v2] defaultSelectIndex:0];
        [self addChildViewController:_container];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleToNavBar:self.title];
    
    [self.view addSubview:self.segment];
    [self.view addSubview:self.container.view];
    self.container.view.frame = CGRectMake(0, self.segment.bottom, SCREEN_WIDTH, self.view.height - self.segment.bottom);
}


#pragma mark - lazyloading
- (SPPageMenu *)segment {
    if (!_segment) {
        _segment = [[SPPageMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) trackerStyle:SPPageMenuTrackerStyleLine];
        _segment.delegate = self;
        _segment.selectedItemTitleColor = LLTheme.mainColor;
        _segment.unSelectedItemTitleColor = LLTheme.mainColor;
        _segment.itemTitleFont = [UIFont systemFontOfSize:19];
        _segment.tracker.backgroundColor = LLTheme.mainColor;
        _segment.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        [_segment setItems:@[@"聊天教学", @"恋爱解析"] selectedItemIndex:0];
    }
    return _segment;
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (fromIndex != toIndex) {
        [self.container transitionToIndex:toIndex completion:^(BOOL isFinished) {
            //
        }];
    }
    
}
@end
