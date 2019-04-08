//
//  LLTheme.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLTheme : NSObject
+ (UIColor *)mainColor;

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

NS_ASSUME_NONNULL_END
