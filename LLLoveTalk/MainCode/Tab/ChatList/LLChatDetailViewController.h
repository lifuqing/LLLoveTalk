//
//  LLChatDetailViewController.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/16.
//

#import "LLContainerListViewController.h"

typedef enum : NSUInteger {
    EChatListTypeJiaoXue,
    EChatListTypeJieXi,
} EChatListType;

NS_ASSUME_NONNULL_BEGIN

@interface LLChatDetailViewController : LLContainerListViewController
@property (nonatomic, assign) EChatListType chatListType;

- (instancetype)initWithContentId:(NSString *)contentId;
@end

NS_ASSUME_NONNULL_END
