//
//  LLAiMessageListModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/9.
//

#import "LLAiMessageListModel.h"

@implementation LLMessageItemModel

@end

@implementation LLAiMessageListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLMessageItemModel class]};
}

@end
