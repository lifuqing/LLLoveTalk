//
//  LLBaseViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLBaseViewController.h"

@interface LLBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation LLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LLTheme.mainBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)addTopCloseWithTitle:(NSString *)title {
    WEAKSELF();
    [self.navBar addTopCloseBlock:^{
        [weakSelf commonPushBack];
    } title:title];
    [self.view addSubview:self.navBar];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.navigationController.viewControllers count] == 1) {
        return NO;
    }else{
        return YES;
    }
}

- (LLNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[LLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, IS_IPhoneXSeries ? SafeNavBarHeight : (NormalNavBarHeight + NormalStatusBarHeight))];
    }
    return _navBar;
}
@end
