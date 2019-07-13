//
//  LLCommentListResponseModel.m
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLCommentListResponseModel.h"
@implementation LLCommentItemModel
- (NSDictionary *)textAttributes {
    return @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size: 14], NSForegroundColorAttributeName:LLTheme.titleSecondColor};
}
@end

@implementation LLCommentListResponseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [LLCommentItemModel class]};
}

@end
