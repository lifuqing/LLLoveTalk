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
@property(nonatomic, assign)BOOL isAppStore;   //是否渠道是appstore，yes是，no越狱渠道

//推送信鸽需要的token
@property(nonatomic, copy)NSString *deviceToken;

//PID
@property(nonatomic, copy)NSString *pid;
@property(nonatomic, copy)NSString *secret;

//Server
@property(nonatomic, copy)NSString *server;
@property(nonatomic, copy)NSString *userServer;

//新浪微博
@property(nonatomic, copy)NSString *sinaWBAppId;
@property(nonatomic, copy)NSString *sinaWBSecret;

//腾讯微博
@property(nonatomic, copy)NSString *tencentWBAppId;
@property(nonatomic, copy)NSString *tencentWBSecret;

//微信
@property(nonatomic, copy)NSString *weixinAppId;
@property(nonatomic, copy)NSString *weixinSecret;

//QQ互联
@property(nonatomic, copy)NSString *tencentQQAppId;
@property(nonatomic, copy)NSString *tencentQQSecret;

//百度地图
@property(nonatomic, copy)NSString *baiduMapAppId;
@property(nonatomic, copy)NSString *baiduMapSecret;

//友盟统计
@property(nonatomic, copy)NSString *umAppKey;

//百度统计
@property(nonatomic, copy)NSString *baiduAppKey;

//腾讯信鸽
@property(nonatomic, copy)NSString *xgAppId;
@property(nonatomic, copy)NSString *xgAppKey;

//////////////////////////////////////

//支付宝
@property(nonatomic, copy)NSString *aliPartnerID;   //商户ID
@property(nonatomic, copy)NSString *aliSellerID;    //账户ID
@property(nonatomic, copy)NSString *aliPrivateKey;  //账户KEY

//微信
@property(nonatomic, copy)NSString *weixinPartnerID;    //财付通商户身份的标识
@property(nonatomic, copy)NSString *weixinPartnerKey;   //财付通商户权限密钥 Key
@property(nonatomic, copy)NSString *weixinPaySignKey;   //支付请求中用于加密的密钥 Key

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
