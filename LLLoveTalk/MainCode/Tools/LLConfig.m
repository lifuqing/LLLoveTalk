//
//  LLConfig.m
//  LLLoveTalk
//
//  Created by lifuqing on 2019/4/7.
//

#import "LLConfig.h"
#import "UIDevice+LLTools.h"

@implementation LLConfig

+(LLConfig *)sharedInstance
{
    static LLConfig *config = nil;
    if (config == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            config = [[LLConfig alloc] init];
            [config loadConfig];
        });
    }
    
    return config;
}

- (NSDictionary *)configDictionary{
    return @{@"debug"   : @{@"server"   : @"http://test1.e.kumi.cn",
                            @"user"     : @"http://test1.e.kumi.cn",
                            @"pid"          : @{@"iphone"   : @"appstore",
                                                @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"kumi",
                                            @"ipad"     : @"kumi"}
                            },
             @"release" : @{@"server"   : @"http://e.kumi.cn",
                            @"user"     : @"http://e.kumi.cn",
                            @"pid"          : @{@"iphone"   : @"appstore",
                                                @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"kumi",
                                            @"ipad"     : @"kumi"}
                            },
             @"share"   : @{@"sinaWB"   : @{@"secret"   : @"",
                                            @"appid"    : @""},
                            @"weixin"   : @{@"secret"   : @"",
                                            @"appid"    : @""},
                            @"tencentQQ": @{@"secret"   : @"",
                                            @"appid"    : @""}
                            },
             @"sdk"     : @{@"baiduMap" : @{@"ak"       : @"",
                                            @"appid"    : @""},
                            @"um"       : @{@"appKey"   : @""},
                            @"baidu"    : @{@"appKey"   : @""},
                            @"xg"       : @{@"appid"    : @"",
                                            @"appKey"   : @""},
                            },
             @"pay"     : @{@"alipay"   : @{@"partnerid": @"2088811544681356",
                                            @"sellerid" : @"happyweekend_2080@163.com",
                                            @"key"      : @"MIICXAIBAAKBgQC1HI2DrmQZaZgXLIpDiGjs/ge6vcfsPcBgI/xaChqUnBgnyeJFCEKC7FHL3tVGr0ZyQSYh+sdo7kZKO/KCqjpZHokghCGMwbmSq9dTo4UQGEkC5qUlvYsKYgP+a+aFG+2ECvjFmqGU96jCTxZGl5UGotj2aZ08x2uKWSDjeVBfxwIDAQABAoGBAJqflfImoS9RB5hBXonpnCs5dj/oZxc6YVOzZW850RevbLALnDJzqtU8DVmRFWUTn4FMPdIk2LqtMzWNmK4Vx1l+JBUjW19iv84AP7Hx9y+hk3zrJqK5JTZalW3zXhDf1zBLVoFVmzWhipNjtGQzGvZh/Ehmtxb0BWbF50eywjgBAkEA547SJ7QNzn0DhxlghmNnXxbQob/3AW/3AxWrI9GbuHqWW6S/L/sF1ZGEiUoZC0RXdkLsbLM5qGXt2OVbNhiBQQJBAMg6kMw12NrvnduMA25ZEYOFqFsiLCxwp8JvyXfnNkORTuPuk8te/F7sd3dulcIyxeHB/PGRz2Meq+VD44EIFwcCQBtBYlcuCFn/uQST5hqrZKV6qAAB+m7+4NJKIKTMrUmflEchMyfQojUrNbB7OktrNehDpFR/HBBIPyDCjmPlqoECQASmZ4p2jay39+CLZeEALInzZq+HIaN+kkbPtcwVEIuNKlncxo3ojM/fif66ELxL1ZCioq8xhbF1muReKUBr4a0CQC5JGYSeLwPIZaEnKAyLTcAt2KzFZw991lhgpV8T6cKkAncrFCvszYmP87LeqExb4tb9URmnGPnpxCyMrG7ZLEY="
                                            },
                            @"weixin"   : @{@"partnerid": @"",
                                            @"key"      : @""
                                            }
                            }
             };
}
-(void)loadConfig
{
    NSString *mode = _isDebug ? @"debug" : @"release";
    
    NSDictionary *dict = [self configDictionary];
    NSString *pidKey = @"pid";

    self.pid = [[[dict objectForKey:mode] objectForKey:pidKey] objectForKey:@"iphone"];
    self.secret = [[[dict objectForKey:mode] objectForKey:@"secret"] objectForKey:@"iphone"];
    
    self.server = [[dict objectForKey:mode] objectForKey:@"server"];
    self.userServer = [[dict objectForKey:mode] objectForKey:@"user"];
    
    NSDictionary *share = [dict objectForKey:@"share"];
    
    self.sinaWBAppId     = [[share objectForKey:@"sinaWB"] objectForKey:@"appid"];
    self.sinaWBSecret    = [[share objectForKey:@"sinaWB"] objectForKey:@"secret"];
    
    self.tencentWBAppId  = [[share objectForKey:@"tencentWB"] objectForKey:@"appid"];
    self.tencentWBSecret = [[share objectForKey:@"tencentWB"] objectForKey:@"secret"];
    
    self.weixinAppId     = [[share objectForKey:@"weixin"] objectForKey:@"appid"];
    self.weixinSecret    = [[share objectForKey:@"weixin"] objectForKey:@"secret"];
    
    self.tencentQQAppId  = [[share objectForKey:@"tencentQQ"] objectForKey:@"appid"];
    self.tencentQQSecret = [[share objectForKey:@"tencentQQ"] objectForKey:@"secret"];
    
    NSDictionary *sdk = dict[@"sdk"];
    self.baiduMapAppId  = sdk[@"baiduMap"][@"appid"];
    self.baiduMapSecret = sdk[@"baiduMap"][@"ak"];
    
    self.umAppKey       = sdk[@"um"][@"appKey"];
    
    self.baiduAppKey    = sdk[@"baidu"][@"appKey"];
    
    self.xgAppId        = sdk[@"xg"][@"appid"];
    self.xgAppKey       = sdk[@"xg"][@"appKey"];
    
    NSDictionary *pay = dict[@"pay"];
    self.aliPartnerID    = pay[@"alipay"][@"partnerid"];
    self.aliSellerID     = pay[@"alipay"][@"sellerid"];
    self.aliPrivateKey   = pay[@"alipay"][@"key"];
    
    self.weixinPartnerID = pay[@"weixin"][@"partnerid"];
    
}


- (NSString *)appVersion{
    return [[UIDevice currentDevice] appVersion];
}

- (NSString *)scheme{
    return @"loveTalk";
}

-(void)setIsDebug:(BOOL)isDebug
{
    _isDebug = isDebug;
    [self loadConfig];
}
-(void)setIsNeedLog:(BOOL)isNeedLog
{
    _isNeedLog = isNeedLog;
}


/**
 *  基础参数绑定
 *
 *  @return 字典
 */
-(NSMutableDictionary *)commonParams{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //YOUKU合作ID，必选参数。需申请获得。
    dict[@"pid"]=[LLConfig sharedInstance].pid;
    
    //版本号
    dict[@"appver"]=[LLConfig sharedInstance].appVersion ? [LLConfig sharedInstance].appVersion : @"";
    //品牌
    dict[@"brand"] = @"apple";
    //机型
    if ([UIDevice currentDevice].machine) {
        dict[@"btype"] = [[UIDevice currentDevice] machine];
    }
    //操作系统
    dict[@"os"] = @"ios";
    //系统版本
    if ([[UIDevice currentDevice] systemVersion]) {
        dict[@"osver"] = [[UIDevice currentDevice] systemVersion];
        dict[@"os_ver"] = [[UIDevice currentDevice] systemVersion]; //统计sdk的名称
    }
    //useragent
    dict[@"useragent"]=[[UIDevice currentDevice] defaultUserAgent];
    //screen
    dict[@"wt"]=@(SCREEN_WIDTH);
    dict[@"ht"]=@(SCREEN_HEIGHT);
    
    return dict;
}
@end
