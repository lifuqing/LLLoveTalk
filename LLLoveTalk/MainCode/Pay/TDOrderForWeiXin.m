//
//  TDOrderForWeiXin.m
//  HappyWeek
//
//  Created by 李福庆 on 15/4/6.
//
//

#import "TDOrderForWeiXin.h"
#import "LLSNItem.h"
#import "UIDevice+LLTools.h"

/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
#define WXAppId @"wxd930ea5d5a258f4f"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
#define WXAppKey @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K"

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
#define WXAppSecret @"db426a9829e4b49a0dcac7b4162da6b6"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
#define WXPartnerKey @"8934e7d15453e97507ef794cf7b0519d"

/**
 *  微信公众平台商户模块生成的ID
 */
#define WXPartnerId @"1900000109"

#define ORDER_PAY_NOTIFICATION @"OrderPayNotification"

#define AccessTokenKey @"access_token"
#define PrePayIdKey @"prepayid"
#define errcodeKey @"errcode"
#define errmsgKey @"errmsg"
#define expiresInKey @"expires_in"

@interface TDOrderForWeiXin()
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *traceId;
@end

@implementation TDOrderForWeiXin

- (id)initWithItem:(id)item{
    self = [self init];
    if (self) {
        if ([item isMemberOfClass:[LLSNItem class]]) {
            self.tradeNO = ((LLSNItem *)item).type_sn; //订单ID（由商家自行制定）
            self.productName = ((LLSNItem *)item).title; //商品标题
            //        self.productDescription = item.body; //商品描述
            self.amount = [NSString stringWithFormat:@"%.f",[((LLSNItem *)item) totalPrice] * 100]; //商品价格
        }
//
//        //将商品信息拼接成字符串
//        NSString *orderSpec = [self description];
//        NSLog(@"orderSpec = %@",orderSpec);
//        
//        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner([LLConfig sharedInstance].aliPrivateKey);
//        NSString *signedString = [signer signString:orderSpec];
//        
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        self.orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                            orderSpec, signedString, @"RSA"];
//        
    }
    return self;
}


// 构造订单参数列表
- (NSDictionary *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];   // 获取时间戳
    self.nonceStr = [self genNonceStr];     // 获取32位内的随机串, 防重发
    self.traceId = [self genTraceId];       // 获取商家对用户的唯一标识
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[LLConfig sharedInstance].weixinAppId forKey:@"appid"];
    [params setObject:[LLConfig sharedInstance].weixinSecret forKey:@"appkey"];
    [params setObject:self.timeStamp forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:[self genPackage] forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    return params;
}

#pragma mark - 生成各种参数
// 获取时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 *  获取32位内的随机串, 防重发
 *
 *  注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [[NSString stringWithFormat:@"%d", arc4random() % 10000] md5Digest];
    return self.tradeNO;
}

/**
 *  获取商家对用户的唯一标识
 *
 *  traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
 *  建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}


- (NSString *)genOutTradNo
{
    return self.tradeNO;
}

// 订单详情
- (NSString *)genPackage
{
    // 构造订单参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:self.productName forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];//通知网址
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"];
    [params setObject:[LLConfig sharedInstance].weixinPartnerID forKey:@"partner"];
    [params setObject:[[UIDevice currentDevice] localIPAddress] forKey:@"spbill_create_ip"];
    [params setObject:self.amount forKey:@"total_fee"];    // 1 =＝ ¥0.01
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:[LLConfig sharedInstance].weixinPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[[package copy] md5Digest] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in sortedKeys)
    {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}

// 签名
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [signString sha1];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}



@end
