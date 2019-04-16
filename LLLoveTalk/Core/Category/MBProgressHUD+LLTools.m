//
//  MBProgressHUD+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/8.
//

#import "MBProgressHUD+LLTools.h"

@implementation MBProgressHUD (LLTools)

+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time {
    return [self showMessage:message inView:view autoHideTime:time interactionEnabled:YES];
}


+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time interactionEnabled:(BOOL)interactionEnabled {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(view?:[UIApplication sharedApplication].keyWindow) animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.userInteractionEnabled = interactionEnabled;
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}

+ (instancetype)showMessage:(NSString *)message inView:(UIView *)view autoHideTime:(CGFloat)time interactionEnabled:(BOOL)interactionEnabled completion:(MBProgressHUDCompletionBlock)completionBlock {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(view?:[UIApplication sharedApplication].keyWindow) animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.userInteractionEnabled = interactionEnabled;
    [hud hideAnimated:YES afterDelay:time];
    hud.completionBlock = completionBlock;
    return hud;
}
@end
