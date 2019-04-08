//
//  LLNavigationBar.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNavigationBar : UIView

- (void)addTopBackBlock:(dispatch_block_t)backBlock title:(NSString *)title;
- (void)addTopCloseBlock:(dispatch_block_t)closeBlock title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END