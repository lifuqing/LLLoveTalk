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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.navigationController.viewControllers count] == 1) {
        return NO;
    }else{
        return YES;
    }
}
@end
