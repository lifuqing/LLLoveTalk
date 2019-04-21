//
//  LLChatDetailTableViewCell.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/17.
//

#import "LLBaseTableViewCell.h"
#import "LLChatDetailListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLChatDetailTableViewCell : LLBaseTableViewCell
@property (nonatomic, copy) dispatch_block_t imageDownloadFinishBlock;
@end

NS_ASSUME_NONNULL_END
