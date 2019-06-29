//
//  LLBuyItemTableViewCell.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLBaseTableViewCell.h"
#import "LLProductListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBuyItemTableViewCell : LLBaseTableViewCell
@property (nonatomic, copy) void (^clickBuyBlock)(LLBuyItemModel *item);
@end

NS_ASSUME_NONNULL_END
