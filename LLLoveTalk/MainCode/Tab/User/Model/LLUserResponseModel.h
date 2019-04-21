//
//  LLUserResponseModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/20.
//

#import "LLBaseResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserResponseModel : LLBaseResponseModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) BOOL ispaid;
@property (nonatomic, assign) NSInteger remaindays;
@end

NS_ASSUME_NONNULL_END
