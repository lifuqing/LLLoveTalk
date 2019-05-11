//
//  LLConfig.h
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLConfig : NSObject

@property(nonatomic, assign)BOOL isDebug;
@property(nonatomic, assign)BOOL isNeedLog;
///是否正处于苹果审核中
@property(nonatomic, assign)BOOL isCheck;

//PID
@property(nonatomic, copy)NSString *pid;
@property(nonatomic, copy)NSString *secret;

//Server
@property(nonatomic, copy)NSString *server;

/// IAP shareSecret
@property (nonatomic, copy) NSString *shareSecret;

//////////////////////////////////////

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy, readonly) NSString *scheme;


+(LLConfig *)sharedInstance;

/**
 *  基础参数绑定
 *
 *  @return 字典
 */
-(NSMutableDictionary *)commonParams;
@end

NS_ASSUME_NONNULL_END
