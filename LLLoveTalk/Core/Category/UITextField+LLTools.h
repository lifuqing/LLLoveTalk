//
//  UITextField+LLTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LLTools)
+ (instancetype)ll_textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align;
@end

NS_ASSUME_NONNULL_END
