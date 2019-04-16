//
//  LLChatDetailListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/16.
//

#import "LLChatDetailListResponseModel.h"
@implementation LLChatDetailItemModel
@end

@implementation LLChatDetailListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLChatDetailItemModel class]};
}
@end
