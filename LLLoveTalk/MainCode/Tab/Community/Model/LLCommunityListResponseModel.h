//
//  LLCommunityListResponseModel.h
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCommunityItemModel : LLBaseModel
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *head_file;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSArray <NSString *> *images;
@property (nonatomic, assign) NSInteger publish_time;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) BOOL collect;

- (NSDictionary *)textAttributes;
@end

@interface LLCommunityListResponseModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END
