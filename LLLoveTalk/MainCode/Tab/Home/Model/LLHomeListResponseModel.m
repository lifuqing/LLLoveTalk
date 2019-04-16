//
//  LLHomeListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/11.
//

#import "LLHomeListResponseModel.h"
@implementation LLTagResponseModel
@end

@implementation LLHomeItemResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"child" : [LLTagResponseModel class]};
}
@end

@implementation LLHomeListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLHomeItemResponseModel class]};
}

@end
