//
//  UIAlertController+LLTools.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/20.
//

#import "UIAlertController+LLTools.h"

@implementation UIAlertController (LLTools)

+ (void)ll_showAlertWithTarget:(nonnull UIViewController *)target
                         title:(nullable NSString *)title
                       message:(nullable NSString *)message
                   cancelTitle:(nullable NSString *)cancelTitle
                   otherTitles:(nullable NSArray<NSString *> *)otherTitles
                    completion:(void(^ __nullable)(NSInteger buttonIndex))completion {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    BOOL hasCancel = cancelTitle.length > 0;
    if (hasCancel) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(0);
            }
        }];
        [alert addAction:actionCancel];
    }
    
    [otherTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *other = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger realIndex = hasCancel ? (idx + 1) : idx;
            if (completion) {
                completion(realIndex);
            }
        }];
        [alert addAction:other];
    }];
    
    if ([target respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [target presentViewController:alert animated:YES completion:nil];
    }
    
}
@end
