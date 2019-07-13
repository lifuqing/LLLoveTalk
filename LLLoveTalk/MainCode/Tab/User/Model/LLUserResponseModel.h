//
//  LLUserResponseModel.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/20.
//

#import "LLBaseResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserResponseModel : LLBaseResponseModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) BOOL ispaid;
@property (nonatomic, assign) NSInteger remaindays;
@property (nonatomic, copy) NSString *sig_self;
@property (nonatomic, copy) NSString *sig_love;
@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, copy) NSString *head_file;
@end

NS_ASSUME_NONNULL_END
