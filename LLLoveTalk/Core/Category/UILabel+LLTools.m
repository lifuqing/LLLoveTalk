//
//  UILabel+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import "UILabel+LLTools.h"

@implementation UILabel (LLTools)

+ (instancetype)ll_labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlign:(NSTextAlignment)align {
    UILabel *label = [[[self class] alloc ] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = align;
    return label;
}
@end
