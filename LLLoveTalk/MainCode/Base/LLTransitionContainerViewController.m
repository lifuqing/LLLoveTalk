//
//  LLTransitionContainerViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTransitionContainerViewController.h"

@interface LLTransitionContainerViewController ()

/// 当前选中VC的index，默认为0
@property (nonatomic, assign, readwrite) NSUInteger selectedIndex;
/// 当前选中VC
@property (nonatomic, strong, readwrite) UIViewController *selectedViewController;

@end

@implementation LLTransitionContainerViewController

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                     defaultSelectIndex:(NSUInteger)defaultSelectIndex {
    
    self = [super init];
    if (self) {
        for (NSUInteger i = 0; i < viewControllers.count; ++i) {
            [self addChildViewController:viewControllers[i]];
        }
        _selectedIndex = defaultSelectIndex < viewControllers.count ? defaultSelectIndex : 0;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.selectedViewController = self.childViewControllers[self.selectedIndex];

    self.selectedViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.selectedViewController.view];
}

- (void)updateContainerWithViewControllers:(NSArray<UIViewController *> *)viewControllers defaultSelectIndex:(NSUInteger)defaultSelectIndex {
    
    NSArray *childVCArray = [self.childViewControllers copy];
    for (UIViewController *tmpVC in childVCArray) {
        [tmpVC willMoveToParentViewController:nil];
        [tmpVC removeFromParentViewController];
    }
    
    NSArray *subViews = [self.view.subviews copy];
    for (UIView *tmpView in subViews) {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < viewControllers.count; ++i) {
        [self addChildViewController:viewControllers[i]];
    }
    self.selectedIndex = defaultSelectIndex < viewControllers.count ? defaultSelectIndex : 0;
    self.selectedViewController = viewControllers[self.selectedIndex];
    
    self.selectedViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.selectedViewController.view];
}

- (void)transitionToIndex:(NSUInteger)toIndex completion:(void (^ __nullable)(BOOL isFinished))completion {
    if (toIndex >= self.childViewControllers.count || toIndex == self.selectedIndex) {
        return;
    }
    UIViewController *newController = self.childViewControllers[toIndex];
    newController.view.frame = self.view.bounds;
    // 防止快速点击切换时视图消失的情况（一般发生在动画为执行完就开始下一个切换任务），经测试，self.view.subviews.count 一直等于2
    [self.view addSubview:newController.view];
    [self transitionFromViewController:self.selectedViewController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            self.selectedIndex = toIndex;
            self.selectedViewController = newController;
        }
        
        if (completion) {
            completion(finished);
        }
    }];
}

@end
