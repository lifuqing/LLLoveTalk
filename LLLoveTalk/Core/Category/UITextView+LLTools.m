//
//  UITextView+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/18.
//

#import "UITextView+LLTools.h"

@implementation UITextView (LLTools)

+ (instancetype)ll_textViewWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align {
    UITextView *label = [[[self class] alloc ] initWithFrame:frame];
    label.editable = NO;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = align;
    return label;
}
@end
