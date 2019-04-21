//
//  LLCommonMarco.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/5.
//

#ifndef LLCommonMarco_h
#define LLCommonMarco_h

#define LLImage(name) [UIImage imageNamed:(name)]

#define DLog( s, ... )     { if([[LLConfig sharedInstance] isNeedLog]) { NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ); } }

#define IS_IPhoneXSeries ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
)\
:\
NO)

#define NormalTabBarHeight                  49.0f
#define NormalNavBarHeight                  44.0f


#define SafeNavgBarAreaTop   (IS_IPhoneXSeries ? 44 : 0)
#define SafeBottomAreaHeight (IS_IPhoneXSeries ? 34 : 0)
#define SafeNavBarHeight (SafeNavgBarAreaTop + NormalNavBarHeight)
#define SafeTabBarHeight (SafeBottomAreaHeight + NormalTabBarHeight)


#define NormalStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define SafeStatusBarHeight (20 - NormalStatusBarHeight)

#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBS(s) RGB(s, s, s)



#define SYSTEM_VERSION_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending



#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#define STRONGSELF() __strong typeof(weakSelf) strongSelf = weakSelf
#define WEAKSELF() __weak __typeof(&*self) weakSelf = self

#endif /* LLCommonMarco_h */
