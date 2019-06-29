//
//  UITextView+LLTools.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (LLTools)
+ (instancetype)ll_textViewWithFrame:(CGRect)frame;
+ (instancetype)ll_textViewWithFrame:(CGRect)frame text:(nullable NSString *)text font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor textAlign:(NSTextAlignment)align;

@end

NS_ASSUME_NONNULL_END
