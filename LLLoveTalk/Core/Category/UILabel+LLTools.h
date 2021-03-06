//
//  UILabel+LLTools.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LLTools)
+ (instancetype)ll_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align;
@end

NS_ASSUME_NONNULL_END
