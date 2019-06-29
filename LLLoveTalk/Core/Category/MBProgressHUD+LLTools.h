//
//  MBProgressHUD+LLTools.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/8.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (LLTools)
///显示toast，view为nil的时候显示在window上
+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time;
///显示toast，view为nil的时候显示在window上，interactionEnabled=YES可交互，NO不可交互，默认可交互
+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time interactionEnabled:(BOOL)interactionEnabled;
///显示toast，view为nil的时候显示在window上，interactionEnabled=YES可交互，NO不可交互，默认可交互,completionBlock 为消失回调
+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time interactionEnabled:(BOOL)interactionEnabled completion:(MBProgressHUDCompletionBlock)completionBlock;
@end

NS_ASSUME_NONNULL_END
