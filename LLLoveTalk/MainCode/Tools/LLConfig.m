//
//  LLConfig.m
//  LLAiLove
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

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _isPassedCheck = [userDefaults boolForKey:@"com.config.isPassedCheck"];
    }
    return self;
}
- (void)setIsPassedCheck:(BOOL)isPassedCheck {
    _isPassedCheck = isPassedCheck;
    [[NSUserDefaults standardUserDefaults] setBool:isPassedCheck forKey:@"com.config.isPassedCheck"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary *)configDictionary{
    return @{@"debug"   : @{@"server"   : @"http://api.dgthp.com",
                            @"serverNew": @"http://47.110.158.235:5000",
                            @"pid"      : @{@"iphone"   : @"appstore",
                                            @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"",
                                            @"ipad"     : @""}
                            },
             @"release" : @{@"server"   : @"http://api.dgthp.com",
                            @"serverNew": @"",
                            @"pid"      : @{@"iphone"   : @"appstore",
                                            @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"",
                                            @"ipad"     : @""}
                            },
             @"shareSecret": @"778cb59a5a2d403a9abbd40fc6a78de9",
             @"OSSClient":@{
                     @"OSS_ACCESSKEY" : @"LTAIrik5fP8d0Ecl",
                     @"OSS_SECRETKEY" : @"WzpjdK8JkqChIzeGTMNDF7KJSltTZ8",
                     @"OSS_BUCKETNAME" : @"lianaibaodian123",
                     @"OSS_ENDPOINT" : @"http://oss-cn-shanghai.aliyuncs.com"
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
    self.serverNew = dict[mode][@"serverNew"];
    
    self.shareSecret = dict[@"shareSecret"];
    
    self.OSS_ACCESSKEY = dict[@"OSSClient"][@"OSS_ACCESSKEY"];
    self.OSS_SECRETKEY = dict[@"OSSClient"][@"OSS_SECRETKEY"];
    self.OSS_BUCKETNAME = dict[@"OSSClient"][@"OSS_BUCKETNAME"];
    self.OSS_ENDPOINT = dict[@"OSSClient"][@"OSS_ENDPOINT"];
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
    dict[@"appver"]=[LLConfig sharedInstance].appVersion ?: @"";
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
