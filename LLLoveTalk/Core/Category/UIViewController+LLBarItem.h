//
//  UIViewController+LLBarItem.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LLBarItem)

/**只有图片的按钮*/
- (void)addBackBarItemWithTitle:(NSString *)title;

- (void)addCloseBarItemWithTitle:(NSString *)title;

//增加导航栏标题
- (void)addTitleToNavBar:(NSString *)title;

//返回
- (void)commonPushBack;
@end

NS_ASSUME_NONNULL_END
