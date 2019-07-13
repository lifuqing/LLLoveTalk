//
//  LLMessage.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/10.
//

#import "JSQMessage.h"
#import "LLAiMessageListModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface LLMessage : JSQMessage
///`dialog`,`broadcast`
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *head_file;
@property (nonatomic, assign) BOOL showTimeDesc;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithMessageItemModel:(LLMessageItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
