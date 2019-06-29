//
//  LLProductListResponseModel.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/19.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLBuyItemModel : LLBaseModel
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;
@end

@interface LLProductListResponseModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END
