//
//  UITextView+LLTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (LLTools)

+ (instancetype)ll_textViewWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align;

@end

NS_ASSUME_NONNULL_END
