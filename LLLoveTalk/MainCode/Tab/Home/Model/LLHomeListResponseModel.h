//
//  LLHomeListResponseModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/11.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLTagResponseModel : LLBaseModel
@property (nonatomic, copy) NSString *cateid;
@property (nonatomic, copy) NSString *catename;
@end

@interface LLHomeItemResponseModel : LLBaseModel
@property (nonatomic, copy) NSString *fname;
@property (nonatomic, copy) NSArray<LLTagResponseModel *> *child;
@end

@interface LLHomeListResponseModel : LLListResponseModel

@property (nonatomic, copy) NSString *alert_box;
@end

NS_ASSUME_NONNULL_END
