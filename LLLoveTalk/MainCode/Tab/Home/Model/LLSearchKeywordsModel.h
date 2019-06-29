//
//  LLSearchKeywordsModel.h
//  LLAiLove
//
//  Created by lifuqing on 2019/6/19.
//

#import "LLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLSearchKeywordsModel : LLBaseResponseModel
@property (nonatomic, copy) NSArray<NSString *> *keywords;
@end

NS_ASSUME_NONNULL_END
