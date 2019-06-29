//
//  LLTheme.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTheme.h"

@implementation LLTheme

+ (UIColor *)mainColor {
    return RGB(215, 173, 210);
//    return RGB(220, 89, 119);
}

+ (UIColor *)auxiliaryColor {
    return RGB(244, 222, 227);
}

+ (UIColor *)searchBGColor {
    return RGB(233, 188, 204);
}

+ (UIColor *)mainBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)titleColor {
    return [UIColor blackColor];//RGB(89, 87, 87);
}

+ (UIColor *)subTitleColor {
    return RGBS(137);
}
@end

@implementation LLTheme (TabBar)

+ (UIColor *)tabbarTintColor {
    return [UIColor whiteColor];
}
+ (UIColor *)tabbarNormalColor {
    return [self mainColor];
}
+ (UIColor *)tabbarSelectedColor {
    return [self mainColor];
}

@end


@implementation LLTheme (NavigationBar)
+ (UIColor *)navigationTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationTintColor {
    return [self mainColor];
}
@end

@implementation LLTheme (Font)
+ (UIFont *)navigationTitleFont {
    return [UIFont boldSystemFontOfSize:18];
}
@end

