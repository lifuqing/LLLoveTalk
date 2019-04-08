//
//  LLTheme.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLTheme.h"

@implementation LLTheme

+ (UIColor *)mainColor {
    return [UIColor orangeColor];
}
@end

@implementation LLTheme (TabBar)

+ (UIColor *)tabbarTintColor {
    return [UIColor whiteColor];
}
+ (UIColor *)tabbarNormalColor {
    return [UIColor grayColor];
}
+ (UIColor *)tabbarSelectedColor {
    return [UIColor orangeColor];
}

@end


@implementation LLTheme (NavigationBar)
+ (UIColor *)navigationTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationTintColor {
    return [UIColor purpleColor];
}
@end
