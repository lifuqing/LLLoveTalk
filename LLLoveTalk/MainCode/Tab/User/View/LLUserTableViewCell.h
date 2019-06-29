//
//  LLUserTableViewCell.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserTableViewCell : LLBaseTableViewCell

@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

NS_ASSUME_NONNULL_END
