//
//  UIViewController+LLBarItem.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import "UIViewController+LLBarItem.h"

@implementation UIViewController (LLBarItem)
- (void)addBackBarItemWithTitle:(NSString *)title {
    [self createBackBarItemWithImage:LLImage(@"btn_nav_back")];
    if (title) {
        [self addTitleToNavBar:title];
    }
}
- (void)addCloseBarItemWithTitle:(NSString *)title {
    
    [self createBackBarItemWithImage:LLImage(@"btn_nav_close")];
    if (title) {
        [self addTitleToNavBar:title];
    }
}

- (void)createBackBarItemWithImage:(UIImage *)image {
    //左侧按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -(25-image.size.width), 0, 0)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commonPushBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = backNavigationItem;
}

- (void)commonPushBack {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addTitleToNavBar:(NSString *)title {
    self.navigationItem.title = title;
}

@end
