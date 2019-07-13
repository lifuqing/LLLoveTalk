//
//  LLAiMessageListModel.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/7/9.
//

#import "LLListResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLMessageItemModel : LLBaseModel
@property (nonatomic, copy) NSString *messageid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger timestamp;
///`dialog`,`broadcast`
@property (nonatomic, copy) NSString *model;
///`text`,`image`
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *head_file;

///自己定义的
@property (nonatomic, assign) BOOL showTimeDesc;

@end

@interface LLAiMessageListModel : LLListResponseModel

@end

NS_ASSUME_NONNULL_END
