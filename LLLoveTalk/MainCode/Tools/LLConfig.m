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
    return @{@"debug"   : @{@"server"   : @"https://apillbd.dhhkk.com",
                            @"pid"      : @{@"iphone"   : @"appstore",
                                            @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"",
                                            @"ipad"     : @""}
                            },
             @"release" : @{@"server"   : @"https://apillbd.dhhkk.com",
                            @"pid"      : @{@"iphone"   : @"appstore",
                                            @"ipad"     : @"appstore_hd"},
                            @"secret"   : @{@"iphone"   : @"",
                                            @"ipad"     : @""}
                            },
             @"shareSecret": @"301ca6085dc34796a8f7dd6721e540e6"
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
    
    self.shareSecret = dict[@"shareSecret"];
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
