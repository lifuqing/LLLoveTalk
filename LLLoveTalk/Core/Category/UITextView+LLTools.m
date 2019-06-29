//
//  UITextView+LLTools.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/18.
//

#import "UITextView+LLTools.h"

@implementation UITextView (LLTools)
+ (instancetype)ll_textViewWithFrame:(CGRect)frame {
    return [self ll_textViewWithFrame:frame text:nil font:nil textColor:nil textAlign:NSTextAlignmentLeft];
}

+ (instancetype)ll_textViewWithFrame:(CGRect)frame text:(nullable NSString *)text font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor textAlign:(NSTextAlignment)align {
    UITextView *textView = [[[self class] alloc ] initWithFrame:frame];
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.text = text;
    textView.textColor = textColor;
    textView.font = font;
    textView.textAlignment = align;
    return textView;
}

@end
