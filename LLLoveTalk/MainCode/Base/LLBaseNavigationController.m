//
//  LLBaseNavigationController.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLBaseNavigationController.h"

@interface LLBaseNavigationController ()

@end

@implementation LLBaseNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableDictionary *textAtts = [NSMutableDictionary dictionary];
        textAtts[NSForegroundColorAttributeName]= LLTheme.navigationTitleColor;//设置文字颜色
        textAtts[NSFontAttributeName] = LLTheme.navigationTitleFont;//设置文字大小
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = LLTheme.navigationTintColor;
        [self.navigationBar setTitleTextAttributes:textAtts];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}


@end
