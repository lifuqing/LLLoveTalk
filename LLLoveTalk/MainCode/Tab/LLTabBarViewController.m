//
//  LLTabBarViewController.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTabBarViewController.h"
#import "LLHomeViewController.h"
#import "LLChatContainerViewController.h"
#import "LLUserViewController.h"
#import "LLBaseNavigationController.h"

@interface LLTabBarViewController ()

@end

@implementation LLTabBarViewController

+ (void)initialize {
    //设置底部样式
    UITabBarItem * appeatance = [UITabBarItem appearance];
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attrs[NSForegroundColorAttributeName] = LLTheme.tabbarNormalColor;
    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = LLTheme.tabbarSelectedColor;
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    [appeatance setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [appeatance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].barTintColor = LLTheme.tabbarTintColor;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        LLHomeViewController *vc1 = [[LLHomeViewController alloc] init];
        vc1.title = @"恋爱话术惯例";
        LLChatContainerViewController *vc2 = [[LLChatContainerViewController alloc] init];
        vc2.title = @"聊天实战";
        LLUserViewController *vc3 = [[LLUserViewController alloc] init];
        vc3.title = @"我的";
        
        LLBaseNavigationController *nav1 = [[LLBaseNavigationController alloc] initWithRootViewController:[self configViewController:vc1 title:vc1.title image:nil selectedImage:nil]];
        
        LLBaseNavigationController *nav2 = [[LLBaseNavigationController alloc] initWithRootViewController:[self configViewController:vc2 title:vc2.title image:nil selectedImage:nil]];
        
        LLBaseNavigationController *nav3 = [[LLBaseNavigationController alloc] initWithRootViewController:[self configViewController:vc3 title:vc3.title image:nil selectedImage:nil]];
        
        
        self.viewControllers = @[nav1, nav2, nav3];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [UIColor lightGrayColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    // Do any additional setup after loading the view.
}


- (UIViewController *)configViewController:(UIViewController *)viewController
                                     title:(NSString *)title
                                     image:(UIImage *)image
                             selectedImage:(UIImage *)selectedImage {
    viewController.navigationItem.title = title;
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return viewController;
}

@end
