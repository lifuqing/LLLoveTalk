//
//  LLNavigation.m
//  LLLoveTalk
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
    
    // 找到最上层的那个ViewController
    UIViewController *topViewController = [self topViewController];
    
    if (topViewController == nil)
        return;
    
    UIViewController *parentController = topViewController.parentViewController;
    UIViewController *selectedController = [self currentSelectedNavigationController];
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    
    if (parentController && [parentController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)parentController popViewControllerAnimated:animated];
    }else if (parentController && parentController.navigationController) {
        [parentController.navigationController popViewControllerAnimated:YES];
    }else if ([selectedController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)selectedController popViewControllerAnimated:animated];
    } else if ([rootController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootController popViewControllerAnimated:animated];
    }
}

// pop to the viewController already in NavigationController
- (void)popToViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    
    // 取出根LJBaseTabBarController
    UIViewController *rootViewController = [self windowsRootViewController];
    
    if (!rootViewController)
        return;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *rootTabController = (UITabBarController *)rootViewController;
        NSArray *viewControllers = rootTabController.viewControllers;
        NSInteger selectIndex = -1;
        for (int i = 0; i < viewControllers.count; i++) {
            
            // 遍历TabBarController每个tab的"根NavigationController"
            id tmpController = viewControllers[i];
            if ([tmpController isKindOfClass:[UINavigationController class]]) {
                
                if ([self popToViewController:viewController
                       InNavigationController:(UINavigationController *)tmpController
                                     animated:animated]) {
                    
                    selectIndex = i;
                    break;
                }
            } else {
                
                // 这种情况应该不会出现，万一使用不当需要做一下特殊处理防止出现意外情况
                if (tmpController == viewController) {
                    
                    selectIndex = i;
                    break;
                }
            }
        }
        
        //选中变化的ViewController
        if (selectIndex != -1 && selectIndex != rootTabController.selectedIndex) {
            
            if (rootTabController.delegate &&
                [rootTabController.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
                
                [rootTabController.delegate tabBarController:rootTabController
                                  shouldSelectViewController:rootTabController.viewControllers[selectIndex]];
            }
            rootTabController.selectedIndex = selectIndex;
        }
        
        // 如果在TabBarController每个tab的"根NavigationController"里面都没有找到这个viewController
        if (selectIndex == -1) {
            
            [self pushViewController:viewController animated:animated];
        }
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        BOOL result = [self popToViewController:viewController
                         InNavigationController:(UINavigationController *)rootViewController
                                       animated:animated];
        
        // 压根就没有找到这个viewController
        if (result == NO) {
            
            [self pushViewController:viewController animated:animated];
        }
        
    } else {
        
        //当前已经在最上面一层了
        if (viewController != rootViewController) {
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [rootViewController presentViewController:navController animated:animated completion:nil];
        }
    }
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
    
    [self popToRootTabBarControllerAnimated:NO];
    
    // 取出根LJBaseTabBarController
    UIViewController *rootViewController = [self windowsRootViewController];
    
    if (!rootViewController)
        return;
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        [(UITabBarController *)rootViewController setSelectedIndex:index];
    }
}

- (BOOL)popToViewController:(nonnull UIViewController *)viewController
InNavigationController:(nonnull UINavigationController *)navigationController
animated:(BOOL)animated {
    
    NSInteger count = navigationController.viewControllers.count;
    if (count == 0)
        return NO;
    
    BOOL success = NO;
    for (NSInteger i = count - 1; i >= 0; i--) {
        
        UIViewController *tmpViewController = navigationController.viewControllers[i];
        if (tmpViewController.presentedViewController) {
            
            if ([tmpViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
                
                if ([self popToViewController:viewController
                       InNavigationController:(UINavigationController *)tmpViewController.presentedViewController
                                     animated:animated]) {
                    
                    [navigationController popToViewController:tmpViewController animated:animated];
                    success = YES;
                    break;
                }
                
            } else {
                
                if (tmpViewController.presentedViewController == viewController) {
                    
                    [navigationController popToViewController:tmpViewController animated:animated];
                    success = YES;
                    break;
                }
            }
        } else {
            
            if (tmpViewController == viewController) {
                
                [navigationController popToViewController:tmpViewController animated:animated];
                success = YES;
                break;
            }
        }
    }
    
    return success;
}

// 当前windows的rootViewController
- (UIViewController *)windowsRootViewController {
    /*
     *  [UIApplication sharedApplication].delegate.window.rootViewController ----> UIViewController
     *  如果UIViewController是LLTabBarViewController的话: Tab1, Tab2, Tab3...
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
            blockViewController = [blockViewController performSelector:@selector(selectedViewController)];
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
