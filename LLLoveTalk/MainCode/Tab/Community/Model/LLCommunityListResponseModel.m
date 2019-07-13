//
//  LLCommunityListResponseModel.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommunityListResponseModel.h"
@implementation LLCommunityItemModel

- (NSDictionary *)textAttributes {
    return @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14], NSForegroundColorAttributeName:LLTheme.titleSecondColor};
}
@end


@implementation LLCommunityListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLCommunityItemModel class]};
}

@end
