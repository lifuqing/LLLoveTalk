//
//  LLTagExampleListResponseModel.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/14.
//

#import "LLTagExampleListResponseModel.h"
@implementation LLTagExampleModel
@end

@implementation LLTagExampleListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLTagExampleModel class]};
}
@end
