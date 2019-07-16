//
//  LLAiLoveURLConfig.m
//  LLAiLove
//
//  Created by lifuqing on 2019/4/5.
//

#import "LLAiLoveURLConfig.h"
@interface LLAiLoveURLConfig ()
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *serverNew;
@end

@implementation LLAiLoveURLConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.server = [LLConfig sharedInstance].server;
        self.serverNew = [LLConfig sharedInstance].serverNew;
    }
    return self;
}

- (NSDictionary *)commonParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[UIDevice currentDevice] appVersion] forKey:@"version"];
    [dict setValue:@(![LLConfig sharedInstance].isPassedCheck) forKey:@"check_state"];
    [dict setValue:[LLUser sharedInstance].phone ?:@"" forKey:@"phone"];
    [dict setValue:@"ios" forKey:@"channel"];
    [dict setValue:[LLUser sharedInstance].userid ?:@"" forKey:@"userid"];
    [dict setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"bundleId"];
    return [dict copy];
}

- (NSArray *)loadUrlInfo{
    NSArray *arr = @[
#pragma mark -示例普通接口
                     @{
                         @"parser"     : @"ExampleRequestParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : @"domain",//domain，子类自行维护传入
                         @"url"        : @"/index.php",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         //@"modelClass" : @"LLXXXResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -示例列表接口
                     @{
                         @"parser"     : @"ExampleListParser",//,命名规则XXXXListParser
                         @"server"     : @"domain",//domain，子类自行维护传入
                         @"url"        : @"/zhuanti.php",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLXXXListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -初始化接口
                     @{
                         @"parser"     : @"InitParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/state_check",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         },
#pragma mark -首页列表接口
                     @{
                         @"parser"     : @"HomeListParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/homepage",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLHomeListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -搜索关键词接口
                     @{
                         @"parser"     : @"SearchKeywordsParser",//,命名规则XXXXListParser
                         @"server"     : self.server,
                         @"url"        : @"/get_keywords",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLSearchKeywordsModel"
                         },
#pragma mark -搜索接口
                     @{
                         @"parser"     : @"SearchListParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/search",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLTagExampleListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -恋爱详情列表接口
                     @{
                         @"parser"     : @"LoveDetailListParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/lianai_xiangqing",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLTagExampleListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -发送验证码接口
                     @{
                         @"parser"     : @"SendCodeParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/sendcode",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         //@"modelClass" : @"LLXXXResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -登录接口
                     @{
                         @"parser"     : @"LoginParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/login",   //short url，不带host
                         @"method"     : @"post",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -获取用户信息接口
                     @{
                         @"parser"     : @"GetUserInfoParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/get_user_info",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -获取产品信息接口
                     @{
                         @"parser"     : @"GetProductInfoParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/get_package",   //short url，不带host
                         @"method"     : @"get",      //支持post和get
                         @"cache"      : @(YES),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLProductListResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -通知服务端购买成功接口
                     @{
                         @"parser"     : @"BuyProductNotifyParser", //parser用来区分不同的请求,命名XXXXParser
                         @"server"     : self.server,
                         @"url"        : @"/place_order",   //short url，不带host
                         @"method"     : @"post",      //支持post和get
                         @"cache"      : @(NO),     //是否存取json数据
                         @"params"     : @{},          //该接口默认参数
                         @"modelClass" : @"LLUserResponseModel"  //继承自LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -情感广场列表接口
                     @{
                         @"parser"     : @"LoveCommunityListParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/get_palza_data",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLCommunityListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -发布朋友圈接口
                     @{
                         @"parser"     : @"SendPlazaParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/post_plaza",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -广场内容详情列表接口
                     @{
                         @"parser"     : @"LoveCommentsListParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/get_comments",
                         @"method"     : @"get",
                         @"cache"      : @(YES),
                         @"params"     : @{},
                         @"modelClass" : @"LLCommentListResponseModel"  //继承自LLListResponseModel(列表页)或者LLBaseResponseModel（普通请求）的类名，普通接口可选参数,列表必选
                         },
#pragma mark -发布评论接口
                     @{
                         @"parser"     : @"SendCommentParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/comments",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -收藏接口
                     @{
                         @"parser"     : @"CollectParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/collect",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -填写邀请码接口
                     @{
                         @"parser"     : @"InviteCodeParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/icode_write",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -修改用户名接口
                     @{
                         @"parser"     : @"ModifyUserParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/update_username",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -修改签名接口
                     @{
                         @"parser"     : @"ModifySigSelfParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/update_sigself",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -修改爱情宣言接口
                     @{
                         @"parser"     : @"ModifySigLoveParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/update_siglove",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{}
                         },
#pragma mark -获取机器人广播
                     @{
                         @"parser"     : @"FetchBotMessageParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/bot_get_response",
                         @"method"     : @"get",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLAiMessageListModel"
                         },
#pragma mark -给机器人发送消息
                     @{
                         @"parser"     : @"SendBotMessageParser",//,命名规则XXXXListParser
                         @"server"     : self.serverNew,
                         @"url"        : @"/api/bot_send_message",
                         @"method"     : @"post",
                         @"cache"      : @(NO),
                         @"params"     : @{},
                         @"modelClass" : @"LLAiMessageListModel"
                         },
                     ];
    return arr;
}
@end
