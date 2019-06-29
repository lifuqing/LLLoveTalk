//
//  LLNavigation.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/6.
//

#import "LLNavigation.h"

@implementation LLNavigation

+ (instancetype)sharedInstance {
    
    static LLNavigation *sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedConnector == nil) {
            sharedConnector = [[[self class] alloc] init];
        }
    });
    
    return sharedConnector;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - navigation help function

// 打开一个scheme
- (void)openURLString:(NSString *)urlString {
    //
}


// push a viewController in tab's NavigationController
- (void)pushViewController:(nonnull UIViewController *)controller animated:(BOOL)animated {
    
    // 找到最上层的那个ViewController
    UIViewController *topViewController = [self topViewController];
    
    if (topViewController == nil)
        return;
    
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)topViewController pushViewController:controller animated:animated];
        
    } else if (topViewController.navigationController) {
        
        [topViewController.navigationController pushViewController:controller animated:animated];
        
    }
}

// pop the last pushed viewController
- (void)popViewControllerAnimated:(BOOL)animated {
    [[self realNavigationController] popViewControllerAnimated:animated];
}

// pop to the viewController already in NavigationController
- (void)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    [[self realNavigationController] popToViewController:viewController animated:animated];
}

// pop to the root TabBarController
- (void)popToRootTabBarControllerAnimated:(BOOL)animated {
    
    // 取出根LJBaseTabBarController
    UIViewController *rootViewController = [self windowsRootViewController];
    
    if (!rootViewController)
        return;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *selectedController = [(UITabBarController *)rootViewController selectedViewController];
        if ([selectedController isKindOfClass:[UINavigationController class]]) {
            
            [(UINavigationController *)selectedController popToRootViewControllerAnimated:animated];
        }
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)rootViewController popToRootViewControllerAnimated:animated];
    }
}

// pop to the root TabBarController with tabIndex
- (void)popToRootTabBarControllerAnimated:(BOOL)animated withTabIndex:(NSUInteger)index {
    // 找到最上层的那个ViewController
    UIViewController *topViewController = [self topViewController];
    
    // 防止最上层的是一个模态ViewController
    [topViewController dismissViewControllerAnimated:NO completion:nil];
    
    [self popToRootTabBarControllerAnimated:animated];
    
    // 取出根LJBaseTabBarController
    UIViewController *rootViewController = [self windowsRootViewController];
    
    if (!rootViewController)
        return;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        [(UITabBarController *)rootViewController setSelectedIndex:index];
    }
}

// 当前windows的rootViewController
- (UIViewController *)windowsRootViewController {
    /*
     *  [UIApplication sharedApplication].delegate.window.rootViewController ----> UIViewController
     *  如果UIViewController是LJBaseTabBarController的话: Tab1, Tab2, Tab3...
     *  Tab1 ----> UINavigationController
     */
    // 取出rootViewController
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (![vc isKindOfClass:[UITabBarController class]] && vc.childViewControllers.count > 0) {
        __block UITabBarController *tab = nil;
        [vc.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITabBarController class]]) {
                tab = obj;
                *stop = YES;
            }
        }];
        return tab ?: vc;
    }
    return vc;
}

- (nullable UINavigationController *)realNavigationController {
    
    // 找到最上层的那个ViewController
    UIViewController *topViewController = [self topViewController];
    
    if (topViewController == nil)
        return nil;
    
    UIViewController *parentController = topViewController.parentViewController;
    UIViewController *selectedController = [self currentSelectedNavigationController];
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    
    if (parentController && [parentController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)parentController;
    }else if (parentController && parentController.navigationController) {
        return parentController.navigationController;
    }else if ([selectedController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)selectedController;
    } else if ([rootController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootController;
    }
    return nil;
}

// 当前选中那个tab的NavigationController
- (UINavigationController *)currentSelectedNavigationController {
    
    UIViewController *rootViewController = [self windowsRootViewController];
    
    UINavigationController *selectedNavController = nil;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        // 取出当前高亮Tab的根UINavigationController
        selectedNavController = (UINavigationController *)[(UITabBarController *)rootViewController selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        selectedNavController = (UINavigationController *)rootViewController;
        
    }
    
    return selectedNavController;
}

// 当前最上层的ViewController
- (UIViewController *)topViewController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *blockViewController = window.rootViewController;
    
    while (blockViewController.presentedViewController) {
        blockViewController = blockViewController.presentedViewController;
    }
    
    do {
        if ([blockViewController respondsToSelector:@selector(selectedViewController)]) {
            UITabBarController *tabBarViewController = (UITabBarController *)blockViewController;
            // 1.  当当UITabBarController的tab小于等于5个时，通过selectedViewController即可获得对应tabItem的vc
            // 2.  当UITabBarController的tab超过5个时，前四个可以通过selectedViewController获取，当selectedIndex >= 4时，
            //     moreNavigationController相当于当前选中的navigationVC，通过moreNavigationController.topViewController
            //     即可获取对应navigationVC的topViewController
            // 3.  当tab小于等于5时，moreNavigationController.childViewControllers.count = 1；
            //     当tab大于5时，moreNavigationController.childViewControllers.count = 2；
            if ((tabBarViewController.selectedIndex < 4) ||
                (tabBarViewController.selectedIndex == 4 && tabBarViewController.moreNavigationController.childViewControllers.count == 1)) {
                blockViewController = tabBarViewController.selectedViewController;
            } else {
                blockViewController = tabBarViewController.moreNavigationController.topViewController;
            }
        }
        
        if ([blockViewController respondsToSelector:@selector(topViewController)]) {
            blockViewController = [blockViewController performSelector:@selector(topViewController)];
        }
        
        if (blockViewController.childViewControllers.count) {
            blockViewController = blockViewController.childViewControllers.lastObject;
        }
    } while ([blockViewController respondsToSelector:@selector(selectedViewController)]||
             [blockViewController respondsToSelector:@selector(topViewController)]||
             blockViewController.childViewControllers.count);
    
    return blockViewController;
}
@end
