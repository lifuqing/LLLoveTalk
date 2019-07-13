//
//  LLCommunityDetailViewController.h
//  LLAiLove
//
//  Created by lifuqing on 2019/6/26.
//

#import "LLContainerListViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class LLCommunityItemModel;

@interface LLCommunityDetailViewController : LLContainerListViewController

- (instancetype)initWithContentid:(NSString *)contentid;
@end

NS_ASSUME_NONNULL_END
