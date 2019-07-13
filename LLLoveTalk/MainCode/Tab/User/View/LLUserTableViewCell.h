//
//  LLUserTableViewCell.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserTableViewCell : LLBaseTableViewCell
@property (nonatomic, strong, readonly) UIImageView *arrow;

@property (nonatomic, strong, nullable) UIImageView *thumbView;
@property (nonatomic, strong, nullable) UILabel *titleLabel;
@property (nonatomic, strong, nullable) UILabel *descLabel;
@property (nonatomic, strong, nullable) UITextField *descTextField;

- (void)configUIWithImage:(nullable UIImage *)image title:(nullable NSString *)title desc:(nullable NSString *)desc descTextField:(nullable NSString *)descTextField descPlaceholder:(nullable NSString *)descPlaceholder;
@end

NS_ASSUME_NONNULL_END
