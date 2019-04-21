//
//  LLProductListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/19.
//

#import "LLProductListResponseModel.h"

@implementation LLBuyItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productId"  : @"productid",
             @"productName"  : @"productname",
             @"productPrice"  : @"price"};
}

@end

@implementation LLProductListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLBuyItemModel class]};
}
@end
