//
//  UIAlertController+LLTools.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (LLTools)

+ (void)ll_showAlertWithTarget:(nonnull UIViewController *)target
                         title:(nullable NSString *)title
                       message:(nullable NSString *)message
                   cancelTitle:(nullable NSString *)cancelTitle
                   otherTitles:(nullable NSArray<NSString *> *)otherTitles
                    completion:(void(^ __nullable)(NSInteger buttonIndex))completion;
@end

NS_ASSUME_NONNULL_END
