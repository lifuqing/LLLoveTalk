//
//  LLCommunityListTableViewCell.h
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLBaseTableViewCell.h"
#import "LLCommunityListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCommunityListTableViewCell : LLBaseTableViewCell

@property (nonatomic, copy) void (^favoriteActionBlock)(UIButton *button, LLCommunityItemModel *itemModel);

@property (nonatomic, copy) void (^photoViewActionBlock)(UIImageView *photoView, LLCommunityItemModel *itemModel);
@end

NS_ASSUME_NONNULL_END
