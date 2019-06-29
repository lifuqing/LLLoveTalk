//
//  LLTheme.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLTheme : NSObject
+ (UIColor *)mainColor;
+ (UIColor *)auxiliaryColor;
+ (UIColor *)searchBGColor;
+ (UIColor *)mainBackgroundColor;

+ (UIColor *)titleColor;
+ (UIColor *)subTitleColor;
@end

@interface LLTheme (TabBar)

+ (UIColor *)tabbarTintColor;
+ (UIColor *)tabbarNormalColor;
+ (UIColor *)tabbarSelectedColor;

@end

@interface LLTheme (NavigationBar)
+ (UIColor *)navigationTitleColor;
+ (UIColor *)navigationTintColor;

@end


@interface LLTheme (Font)
+ (UIFont *)navigationTitleFont;

@end
NS_ASSUME_NONNULL_END
