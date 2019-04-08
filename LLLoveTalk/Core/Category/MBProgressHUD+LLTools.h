//
//  MBProgressHUD+LLTools.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (LLTools)
+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time;
///是否可交互，默认可交互
+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time interactionEnabled:(BOOL)interactionEnabled;
@end

NS_ASSUME_NONNULL_END
