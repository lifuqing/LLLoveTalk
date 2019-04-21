//
//  UIButton+LLTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (LLTools)
+ (instancetype)ll_buttonWithFrame:(CGRect)frame target:(id)target normalImage:(UIImage *)normalImage selector:(SEL)selector;

+ (instancetype)ll_buttonWithFrame:(CGRect)frame target:(id)target title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor selector:(SEL)selector;;
@end

NS_ASSUME_NONNULL_END
