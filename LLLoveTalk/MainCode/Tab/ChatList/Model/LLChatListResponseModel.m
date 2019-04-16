//
//  LLChatListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/12.
//

#import "LLChatListResponseModel.h"
@implementation LLChatItemModel
@end

@implementation LLChatListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLChatItemModel class]};
}
@end
