//
//  LLBaseViewController.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import <UIKit/UIKit.h>
#import "LLNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseViewController : UIViewController
@property (nonatomic, strong) LLNavigationBar *navBar;

/**只有图片的按钮*/
- (void)addTopCloseWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
