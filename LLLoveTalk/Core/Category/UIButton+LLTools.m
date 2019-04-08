//
//  UIButton+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import "UIButton+LLTools.h"

@implementation UIButton (LLTools)

+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target normalImage:(UIImage *)normalImage selector:(SEL)selector {
    return [self buttonWithFrame:frame target:target normalImage:normalImage title:nil font:nil textColor:nil selector:selector];
}

+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor selector:(SEL)selector; {
    return [self buttonWithFrame:frame target:target normalImage:nil title:title font:font textColor:textColor selector:selector];
}

+ (instancetype)buttonWithFrame:(CGRect)frame target:(id)target normalImage:(UIImage *)normalImage title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor selector:(SEL)selector; {
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
        [button setTitleColor:textColor forState:UIControlStateNormal];
        
    }
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end