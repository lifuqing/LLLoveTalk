//
//  UITextField+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/4.
//

#import "UITextField+LLTools.h"

@implementation UITextField (LLTools)

+ (instancetype)ll_textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align {
    UITextField *textField = [[[self class] alloc] initWithFrame:frame];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeholder;
    textField.textColor = textColor;
    textField.font = font;
    textField.textAlignment = align;
    return textField;
}

@end
