//
//  LLTagExampleListResponseModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLTagExampleModel : LLBaseModel
@property (nonatomic, assign) BOOL hide;
@property (nonatomic, copy) NSString *dialog;
@end

@interface LLTagExampleListResponseModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END