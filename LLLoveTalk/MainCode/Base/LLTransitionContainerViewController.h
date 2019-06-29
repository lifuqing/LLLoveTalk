//
//  LLTransitionContainerViewController.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLTransitionContainerViewController : LLBaseViewController

/// 初始化成功后，viewControllers可以在vc的childViewControllers中获得
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers defaultSelectIndex:(NSUInteger)defaultSelectIndex;

/// 更新container viewControllers、defaultSelectIndex
- (void)updateContainerWithViewControllers:(NSArray<UIViewController *> *)viewControllers defaultSelectIndex:(NSUInteger)defaultSelectIndex;

/// 跳转到指定VC
- (void)transitionToIndex:(NSUInteger)toIndex completion:(void (^ __nullable)(BOOL isFinished))completion;

/// 当前选中VC的index，默认为0
@property (nonatomic, assign, readonly) NSUInteger selectedIndex;
/// 当前选中VC
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;

@end

NS_ASSUME_NONNULL_END
