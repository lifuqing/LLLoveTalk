//
//  LLNavigation.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import <Foundation/Foundation.h>

#define LLNav [LLNavigation sharedInstance]

NS_ASSUME_NONNULL_BEGIN

@interface LLNavigation : NSObject

+ (instancetype)sharedInstance;


///可以打开 native url 和 web url,注意（针对参数是网址或者汉字的urlstring应该是已经encode过的）
- (void)openURLString:(NSString *)urlString;

/// push a viewController in tab's NavigationController
- (void)pushViewController:(nonnull UIViewController *)controller animated:(BOOL)animated;
/// pop the last pushed viewController
- (void)popViewControllerAnimated:(BOOL)animated;

/// pop to the viewController already in NavigationController
- (void)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated;

/// pop to the root TabBarController with tabIndex
- (void)popToRootTabBarControllerAnimated:(BOOL)animated withTabIndex:(NSUInteger)index;

/// 当前windows的rootViewController
- (UIViewController * __nullable)windowsRootViewController;
/// 当前选中那个tab的NavigationController
- (UINavigationController * __nullable)currentSelectedNavigationController;
/// 当前最上层的ViewController
- (UIViewController * __nullable)topViewController;

@end

NS_ASSUME_NONNULL_END
