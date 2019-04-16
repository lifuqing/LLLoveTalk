//
//  LLChatDetailListResponseModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/16.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface LLChatDetailItemModel : LLBaseModel
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

@interface LLChatDetailListResponseModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END
