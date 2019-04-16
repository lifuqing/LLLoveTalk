//
//  LLChatListResponseModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/12.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLChatItemModel : LLBaseModel
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hide;
@end

@interface LLChatListResponseModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END
