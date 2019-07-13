//
//  LLConfig.h
//  LLAiLove
//
//  Created by lifuqing on 2019/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLConfig : NSObject

@property (nonatomic, assign) BOOL isDebug;
@property (nonatomic, assign) BOOL isNeedLog;
///是否通过苹果审核并发布，默认NO
@property (nonatomic, assign) BOOL isPassedCheck;

//PID
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *secret;

//Server
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *serverNew;

/// IAP shareSecret
@property (nonatomic, copy) NSString *shareSecret;

///OSSClient-OSS_ACCESSKEY
@property (nonatomic, copy) NSString *OSS_ACCESSKEY;
///OSSClient-OSS_SECRETKEY
@property (nonatomic, copy) NSString *OSS_SECRETKEY;
///OSSClient-OSS_BUCKETNAME
@property (nonatomic, copy) NSString *OSS_BUCKETNAME;
///OSSClient-OSS_ENDPOINT
@property (nonatomic, copy) NSString *OSS_ENDPOINT;

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
