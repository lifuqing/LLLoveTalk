//
//  UIViewController+LLBarItem.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import "UIViewController+LLBarItem.h"

@implementation UIViewController (LLBarItem)
- (void)addBackBarItemWithTitle:(NSString *)title {
    [self createBackBarItem];
    [self addTitleToNavBar:title];
}

- (void)createBackBarItem {
    //左侧按钮
    UIImage *image = [UIImage imageNamed:@"btn_fanhui"];
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
    } else if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addTitleToNavBar:(NSString *)title {
    self.navigationItem.title = title;
}

@end
