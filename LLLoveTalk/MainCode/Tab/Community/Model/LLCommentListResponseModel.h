//
//  LLCommentListResponseModel.h
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLListResponseModel.h"
#import "LLCommunityListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCommentItemModel : LLBaseModel
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *head_file;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, assign) NSInteger publish_time;
@property (nonatomic, copy) NSString *floor;

- (NSDictionary *)textAttributes;
@end

@interface LLCommentListResponseModel : LLListResponseModel
@property (nonatomic, strong) LLCommunityItemModel *author;
@end

NS_ASSUME_NONNULL_END
